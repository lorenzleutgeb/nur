#! /bin/sh
set -eu

HTML="${1:-}"

MD="$(mktemp --suffix .md)"

printf "$MD\n"

function md {
	if [ "$HTML" != "" ]
	then
		printf "${@}" >> $MD
	fi
}

md "%s\n" "---"
md "title: DNS Status\n"
md "mainfont: sans-serif\n"
md "monofont: \"'JetBrains Mono', 'Fira Code', 'Source Code Pro', 'Cascadia Code', monospace\"\n"
md "date: %s\n" "$(date --iso-8601=seconds)"
md "author: '[Lorenz Leutgeb](mailto:lorenz@leutgeb.xyz?subject=DNS%%20Status)'\n"
md "abstract: 'This page shows up-to-date authoritative information and whether it has propagated to secondaries.'\n"
md "description: 'DNS Status shows up-to-date authoritative information and whether it has propagated to secondaries.'\n"
md "abstract-title: ''\n"
md "subtitle: Propagation at a Glance\n"
md "lang: en\n"
md "footer: en\n"
md "backgroundcolor: black\n"
md "fontcolor: white\n"
md "linkcolor: '#0088ff'\n"
md "%s\n" "---"

md "\n## Authoritative Servers\n\n"

md "<details><summary><h3 style=\"display:inline;\">Primary</h3></summary>\n\n"

DIG_ARGS="+multiline +norecurse +nostats +noquestion +nocomments +noadditional +noauthority +nocmd"

KNOT_CONF="/etc/knot/knot.conf"

DOMAINS="$(yq -r '.zone[].domain' $KNOT_CONF)"
PRIMARY="$(yq -r '.server.listen[0]' $KNOT_CONF)"

PRIMARY_RESULT="$(mktemp -t resolve-$(date --iso-8601)-XXXX --suffix=-primary)"
dig $DIG_ARGS "@$PRIMARY" SOA ${DOMAINS} > "$PRIMARY_RESULT"

dig +noall +answer "@$PRIMARY" SOA ${DOMAINS} | sed 's/\t\+/  /g'

md "\`\`\`\n%s\n\`\`\`\n\n" "$(cat "$PRIMARY_RESULT" | sed 's/\.\t\t/. \\\n/;s/\t\t\t\t/  /;s/  )/)\n/')"

SECONDARIES="$(dig +noall +answer +short "@$PRIMARY" ns $DOMAINS | grep -v "$(yq -r '"\\(" + ([.zone[].domain] | join("\\|")) + "\\)"' $KNOT_CONF)" | jq -Rr 'split(".") | .[0:-1] | reverse | join(".")' | sort -u)"

EXIT="0"

md "</details>\n\n"
md "### Secondaries\n"

md "<table><thead><tr><th>Server</th><th>Status</th></thead><tbody>\n"

DIFF_FILE="$(mktemp)"

for SECONDARY in ${SECONDARIES}
do
	md "<tr><td>%s</td>" "$SECONDARY"
	printf "%s: " "$SECONDARY"
	SECONDARY_SANE="$(printf "$SECONDARY\n" | jq -Rr 'split(".") | reverse | join(".")')"
	if ! \
		dig $DIG_ARGS "@$SECONDARY_SANE" SOA ${DOMAINS[@]} 2>&1 | \
		diff -U6 --label "primary" "$PRIMARY_RESULT" --label "secondary/$SECONDARY" - \
		> "$DIFF_FILE"
	then
		EXIT="1"
		printf "FAIL\n"
		md "<td>\n"
		md "\`\`\`diff\n"
		cat $DIFF_FILE >> $MD
		md "\`\`\`\n"
		md "</td>\n"
	else
		printf "PASS\n"
		md "<td>✅</td>\n"
	fi
	md "</tr>\n" "$SECONDARY"
done

md "\n</tbody></table>\n\n"

md "## Checkers\n\n<dl>\n\n"

for DOMAIN in ${DOMAINS}
do
	md "<dt>%s</dt><dd><ul style=\"margin-top:0;margin-bottom:16px;\">" "$DOMAIN"
	md "<li style=\"line-height: 200%%;\"><a target=\"_blank\" href=\"https://www.whatsmydns.net/#SOA/%s/%s\">DNS Propagation</a></li>\n" "$DOMAIN" "$(dig +noall +answer +short "@$PRIMARY" SOA "$DOMAIN" | sed 's/\. / /g;s/ /%20/g')"
	md "<li style=\"line-height: 200%%;\"><a target=\"_blank\" href=\"https://mxtoolbox.com/Supertool.aspx?action=dns:%s\">MXToolBox</a></li>\n" "$DOMAIN"
	md "<li style=\"line-height: 200%%;\"><a target=\"_blank\" href=\"https://dnssec-analyzer.verisignlabs.com/%s\">Verisign DNSSEC Analyzer</a></li>\n" "$DOMAIN"
	md "<li style=\"line-height: 200%%;\"><a target=\"_blank\" href=\"https://dnsviz.net/d/%s\">DNSViz</a></li>\n" "$DOMAIN"
	md "</ul></dd>"
done

md "\n</dl>\n\n"


if [ "$HTML" != "" ]
then
	pandoc --highlight-style=zenburn -s $MD -o $HTML
fi

exit "$EXIT"
