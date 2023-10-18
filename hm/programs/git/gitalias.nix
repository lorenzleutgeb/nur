# This file was automatically generated from
#
#   https://github.com/GitAlias/gitalias/raw/main/gitalias.txt
#
# on 2023-10-18T23:41:57+02:00
#
# DO NOT EDIT MANUALLY!
{
  "a" = "add";
  "b" = "branch";
  "c" = "commit";
  "d" = "diff";
  "f" = "fetch";
  "g" = "grep";
  "l" = "log";
  "m" = "merge";
  "o" = "checkout";
  "p" = "pull";
  "s" = "status";
  "w" = "whatchanged";
  "aa" = "add --all";
  "ap" = "add --patch";
  "au" = "add --update";
  "bm" = "branch --merged";
  "bnm" = "branch --no-merged";
  "bed" = "branch --edit-description";
  "bsd" = "!f(){     branch=\"\${1:-$(git rev-parse --abbrev-ref HEAD 2>/dev/null)}\";      git config \"branch.$branch.description\";   };f";
  "bv" = "branch --verbose";
  "bvv" = "branch --verbose --verbose";
  "ca" = "commit --amend";
  "cam" = "commit --amend --message";
  "cane" = "commit --amend --no-edit";
  "caa" = "commit --amend --all";
  "caam" = "commit --amend --all --message";
  "caane" = "commit --amend --all --no-edit";
  "ci" = "commit --interactive";
  "cm" = "commit --message";
  "co" = "checkout";
  "cong" = "checkout --no-guess";
  "cob" = "checkout -b";
  "cp" = "cherry-pick";
  "cpa" = "cherry-pick --abort";
  "cpc" = "cherry-pick --continue";
  "cpn" = "cherry-pick -n";
  "cpnx" = "cherry-pick -n -x";
  "dc" = "diff --cached";
  "ds" = "diff --staged";
  "dw" = "diff --word-diff";
  "dd" = "diff-deep";
  "fa" = "fetch --all";
  "fav" = "fetch --all --verbose";
  "gn" = "grep -n";
  "gg" = "grep-group";
  "lg" = "log --graph";
  "lo" = "log --oneline";
  "lor" = "log --oneline --reverse";
  "lp" = "log --patch";
  "lfp" = "log --first-parent";
  "lto" = "log --topo-order";
  "ll" = "log-list";
  "lll" = "log-list-long";
  "ls" = "ls-files";
  "lsd" = "ls-files --debug";
  "lsfn" = "ls-files --full-name";
  "lsio" = "ls-files --ignored --others --exclude-standard";
  "ma" = "merge --abort";
  "mc" = "merge --continue";
  "mncnf" = "merge --no-commit --no-ff";
  "pf" = "pull --ff-only";
  "pr" = "pull --rebase";
  "prp" = "pull --rebase=preserve";
  "rb" = "rebase";
  "rba" = "rebase --abort";
  "rbc" = "rebase --continue";
  "rbs" = "rebase --skip";
  "rbi" = "rebase --interactive";
  "rbiu" = "rebase --interactive @{upstream}";
  "fixup" = "!f() { TARGET=$(git rev-parse \"$1\"); git commit --fixup=$TARGET && GIT_EDITOR=true git rebase --interactive --autosquash $TARGET~; }; f";
  "rl" = "reflog";
  "rr" = "remote";
  "rrs" = "remote show";
  "rru" = "remote update";
  "rrp" = "remote prune";
  "rv" = "revert";
  "rvnc" = "revert --no-commit";
  "sb" = "show-branch";
  "sm" = "submodule";
  "smi" = "submodule init";
  "sma" = "submodule add";
  "sms" = "submodule sync";
  "smu" = "submodule update";
  "smui" = "submodule update --init";
  "smuir" = "submodule update --init --recursive";
  "ss" = "status --short";
  "ssb" = "status --short --branch";
  "alias" = "!f(){       echo \"Git Alias is project that has a collection of git alias commands.\";       echo \"The purpose is to help make git easier, faster, and more capable.\";       echo \"Free open source repository <https://github.com/gitalias/gitalias>.\";       echo \"\";       echo \"To see your existing git aliases:\";       echo \"    git aliases\";       echo \"\";       echo \"To see your existing git aliases by using git directly:\";       echo \"    git config --get-regexp ^alias\\.\";   };f";
  "add-alias" = "!f() {       if [ $# != 3 ]; then         echo \"Usage: git add-alias ( --local | --global ) <alias> <command>\";         echo \"Error: this command needs 3 arguments.\";         return 2;       fi;       if [ ! -z \"$(git config \"$1\" --get alias.\"$2\")\" ]; then           echo \"Alias '$2' already exists, thus no change happened.\";           return 3;       fi;       git config $1 alias.\"$2\" \"$3\" &&       return 0;       echo \"Usage: git add-alias ( --local | --global ) <alias> <command>\";       echo \"Error: unknown failure.\";       return 1;   }; f";
  "move-alias" = "!f() {       if [ $# != 3 ]; then           echo \"Usage: git move-alias ( --local | --global ) <alias existing name> <new alias name>\";           echo \"Error: this command needs 3 arguments.\";           return 2;       fi;       if [ $2 == $3 ]; then           echo \"The alias names are identical, thus no change happened.\";           return 3;       fi;       if [ -z \"$(git config \"$1\" --get alias.\"$2\")\" ]; then           echo \"Alias '$2' does not exist, thus no change happened.\";           return 4;       fi;       if [ ! -z \"$(git config $1 --get alias.$3)\" ]; then           echo \"Alias '$3' already exists, thus no change happened.\";           return 5;       fi;       git config \"$1\" alias.\"$3\" \"$(git config $1 --get alias.$2)\" &&       git config \"$1\" --unset alias.\"$2\" &&       return 0;       echo \"Usage: git move-alias ( --local | --global ) <alias existing name> <alias new name>\";       echo \"Error: unknown failure.\";       return 1;   };f";
  "last-tag" = "describe --tags --abbrev=0";
  "last-tagged" = "!git describe --tags $(git rev-list --tags --max-count=1)";
  "heads" = "!git log origin/main.. --format='%Cred%h%Creset;%C(yellow)%an%Creset;%H;%Cblue%f%Creset' | git name-rev --stdin --always --name-only | column -t -s';'";
  "diff-all" = "!for name in $(git diff --name-only $1); do git difftool $1 $name & done";
  "diff-changes" = "diff --name-status -r";
  "diff-stat" = "diff --stat --ignore-space-change -r";
  "diff-staged" = "diff --cached";
  "diff-deep" = "diff --check --dirstat --find-copies --find-renames --histogram --color";
  "grep-all" = "!f() { git rev-list --all | xargs git grep \"$@\"; }; f";
  "grep-group" = "grep --break --heading --line-number --color";
  "grep-ack" = "-c color.grep.linenumber=\"bold yellow\"     -c color.grep.filename=\"bold green\"     -c color.grep.match=\"reverse yellow\"     grep --break --heading --line-number";
  "init-empty" = "!f() { git init && git commit --allow-empty --allow-empty-message --message ''; }; f";
  "merge-span" = "!f() { echo $(git log -1 $2 --merges --pretty=format:%P | cut -d' ' -f1)$1$(git log -1 $2 --merges --pretty=format:%P | cut -d' ' -f2); }; f";
  "merge-span-log" = "!git log $(git merge-span .. $1)";
  "merge-span-diff" = "!git diff $(git merge-span ... $1)";
  "merge-span-difftool" = "!git difftool $(git merge-span ... $1)";
  "rebase-branch" = "!f() { git rebase --interactive $(git merge-base $(git default-branch)) HEAD); }; f";
  "orphans" = "fsck --full";
  "rev-list-all-objects-by-size" = "!git rev-list --all --objects  | awk '{print $1}'| git cat-file --batch-check | fgrep blob | sort -k3nr";
  "rev-list-all-objects-by-size-and-name" = "!git rev-list --all --objects | git cat-file --batch-check='%(objecttype) %(objectname) %(objectsize) %(rest)' | awk '/^blob/ {print substr($0,6)}' | sort --numeric-sort --key=2";
  "log-fresh" = "log ORIG_HEAD.. --stat --no-merges";
  "log-list" = "log --graph --topo-order --date=short --abbrev-commit --decorate --all --boundary --pretty=format:'%Cblue%ad %C(auto)%h%Creset -%C(auto)%d%Creset %s %Cblue[%aN]%Creset %Cblue%G?%Creset'";
  "log-list-long" = "log --graph --topo-order --date=iso8601-strict --no-abbrev-commit --decorate --all --boundary --pretty=format:'%Cblue%ad %C(auto)%h%Creset -%C(auto)%d%Creset %s %Cblue[%aN <%aE>]%Creset %Cblue%G?%Creset'";
  "log-my" = "!git log --author $(git config user.email)";
  "log-graph" = "log --graph --all --oneline --decorate";
  "log-date-first" = "!git log --date-order --format=%cI | tail -1";
  "log-date-last" = "log -1 --date-order --format=%cI";
  "log-1-hour" = "log --since=1-hour-ago";
  "log-1-day" = "log --since=1-day-ago";
  "log-1-week" = "log --since=1-week-ago";
  "log-1-month" = "log --since=1-month-ago";
  "log-1-year" = "log --since=1-year-ago";
  "log-my-hour" = "!git log --author $(git config user.email) --since=1-hour-ago";
  "log-my-day" = "!git log --author $(git config user.email) --since=1-day-ago";
  "log-my-week" = "!git log --author $(git config user.email) --since=1-week-ago";
  "log-my-month" = "!git log --author $(git config user.email) --since=1-month-ago";
  "log-my-year" = "!git log --author $(git config user.email) --since=1-year-ago";
  "log-of-format-and-count" = "!f() { format=\"$1\"; shift; git log $@ --format=oneline --format=\"$format\" | awk '{a[$0]++}END{for(i in a){print i, a[i], int((a[i]/NR)*100) \"%\"}}' | sort; }; f";
  "log-of-count-and-format" = "!f() { format=\"$1\"; shift; git log $@ --format=oneline --format=\"$format\" | awk '{a[$0]++}END{for(i in a){print a[i], int((a[i]/NR)*100) \"%\", i}}' | sort -nr; }; f";
  "log-of-format-and-count-with-date" = "!f() { format=\"$1\"; shift; date_format=\"$1\"; shift; git log $@ --format=oneline --format=\"$format\" --date=format:\"$date_format\" | awk '{a[$0]++}END{for(i in a){print i, a[i], int((a[i]/NR)*100) \"%\"}}' | sort -r; }; f";
  "log-of-count-and-format-with-date" = "!f() { format=\"$1\"; shift; date_format=\"$1\"; shift; git log $@ --format=oneline --format=\"$format\" --date=format:\"$date_format\" | awk '{a[$0]++}END{for(i in a){print a[i], int((a[i]/NR)*100) \"%\", i}}' | sort -nr; }; f";
  "log-of-email-and-count" = "!f() { git log-of-format-and-count \"%aE\" $@; }; f";
  "log-of-count-and-email" = "!f() { git log-of-count-and-format \"%aE\" $@; }; f";
  "log-of-hour-and-count" = "!f() { git log-of-format-and-count-with-date \"%ad\" \"%Y-%m-%dT%H\" $@ ; }; f";
  "log-of-count-and-hour" = "!f() { git log-of-count-and-format-with-date \"%ad\" \"%Y-%m-%dT%H\" $@ ; }; f";
  "log-of-day-and-count" = "!f() { git log-of-format-and-count-with-date \"%ad\" \"%Y-%m-%d\" $@ ; }; f";
  "log-of-count-and-day" = "!f() { git log-of-count-and-format-with-date \"%ad\" \"%Y-%m-%d\" $@ ; }; f";
  "log-of-week-and-count" = "!f() { git log-of-format-and-count-with-date \"%ad\" \"%Y#%V\" $@; }; f";
  "log-of-count-and-week" = "!f() { git log-of-count-and-format-with-date \"%ad\" \"%Y#%V\" $@; }; f";
  "log-of-month-and-count" = "!f() { git log-of-format-and-count-with-date \"%ad\" \"%Y-%m\" $@ ; }; f";
  "log-of-count-and-month" = "!f() { git log-of-count-and-format-with-date \"%ad\" \"%Y-%m\" $@ ; }; f";
  "log-of-year-and-count" = "!f() { git log-of-format-and-count-with-date \"%ad\" \"%Y\" $@ ; }; f";
  "log-of-count-and-year" = "!f() { git log-of-count-and-format-with-date \"%ad\" \"%Y\" $@ ; }; f";
  "log-of-hour-of-day-and-count" = "!f() { git log-of-format-and-count-with-date \"%ad\" \"%H\" $@; }; f";
  "log-of-count-and-hour-of-day" = "!f() { git log-of-count-and-format-with-date \"%ad\" \"%H\" $@; }; f";
  "log-of-day-of-week-and-count" = "!f() { git log-of-format-and-count-with-date \"%ad\" \"%u\" $@; }; f";
  "log-of-count-and-day-of-week" = "!f() { git log-of-count-and-format-with-date \"%ad\" \"%u\" $@; }; f";
  "log-of-week-of-year-and-count" = "!f() { git log-of-format-and-count-with-date \"%ad\" \"%V\" $@; }; f";
  "log-of-count-and-week-of-year" = "!f() { git log-of-count-and-format-with-date \"%ad\" \"%V\" $@; }; f";
  "log-refs" = "log --all --graph --decorate --oneline --simplify-by-decoration --no-merges";
  "log-timeline" = "log --format='%h %an %ar - %s'";
  "log-local" = "log --oneline origin..HEAD";
  "log-fetched" = "log --oneline HEAD..origin/main";
  "chart" = "!f() {     git log     --format=oneline     --format=\"%aE %at\"     --since=6-weeks-ago     $* |     awk '     function time_to_slot(t) { return strftime(\"%Y-%m-%d\", t, true) }     function count_to_char(i) { return (i > 0) ? ((i < 10) ? i : \"X\") : \".\" }     BEGIN {       time_min = systime(); time_max = 0;       SECONDS_PER_DAY=86400;     }     {       item = $1;       time = 0 + $2;       if (time > time_max){ time_max = time } else if (time < time_min){ time_min = time };       slot = time_to_slot(time);       items[item]++;       slots[slot]++;       views[item, slot]++;     }     END{       printf(\"Chart time range %s to %s.\\n\", time_to_slot(time_min), time_to_slot(time_max));       time_max_add = time_max += SECONDS_PER_DAY;       for(item in items){         row = \"\";         for(time = time_min; time < time_max_add; time += SECONDS_PER_DAY) {           slot = time_to_slot(time);           count = views[item, slot];           row = row count_to_char(count);         }         print row, item;       }     }';   }; f";
  "churn" = "!f() { git log --all --find-copies --find-renames --name-only --format='format:' \"$@\" | awk 'NF{a[$0]++}END{for(i in a){print a[i], i}}' | sort -rn;};f";
  "summary" = "!f() {     printf \"Summary of this branch...
\";     printf \"%s
\" $(git rev-parse --abbrev-ref HEAD);     printf \"%s first commit timestamp
\" $(git log --date-order --format=%cI | tail -1);     printf \"%s last commit timestamp
\" $(git log -1 --date-order --format=%cI);     printf \"
Summary of counts...
\";     printf \"%d commit count
\" $(git rev-list --count HEAD);     printf \"%d date count
\" $(git log --format=oneline --format=\"%ad\" --date=format:\"%Y-%m-%d\" | awk '{a[$0]=1}END{for(i in a){n++;} print n}');     printf \"%d tag count
\" $(git tag | wc -l);     printf \"%d author count
\" $(git log --format=oneline --format=\"%aE\" | awk '{a[$0]=1}END{for(i in a){n++;} print n}');     printf \"%d committer count
\" $(git log --format=oneline --format=\"%cE\" | awk '{a[$0]=1}END{for(i in a){n++;} print n}');     printf \"%d local branch count
\" $(git branch | grep -v \" -> \" | wc -l);     printf \"%d remote branch count
\" $(git branch -r | grep -v \" -> \" | wc -l);     printf \"
Summary of this directory...
\";     printf \"%s
\" $(pwd);     printf \"%d file count via git ls-files
\" $(git ls-files | wc -l);     printf \"%d file count via find command
\" $(find . | wc -l);     printf \"%d disk usage
\" $(du -s | awk '{print $1}');     printf \"
Most-active authors, with commit count and %%...
\"; git log-of-count-and-email | head -7;     printf \"
Most-active dates, with commit count and %%...
\"; git log-of-count-and-day | head -7;     printf \"
Most-active files, with churn count
\"; git churn | head -7;   }; f";
  "branch-commit-first" = "!f() {       branch=\"\${1:-$(git current-branch)}\";       count=\"\${2:-1}\";     git log --reverse --pretty=%H \"$branch\" |     head -\"$count\";   }; f";
  "branch-commit-last" = "!f() {       branch=\"\${1:-$(git current-branch)}\";       count=\"\${2:-1}\";     git log --pretty=%H \"$branch\" |     head -\"$count\";   }; f";
  "branch-commit-prev" = "!f() {       branch=\"\${1:-$(git current-branch)}\";       count=\"\${2:-1}\";     git log --pretty=%H \"$branch\" |     grep -A \"$count\" $(git rev-parse HEAD) |     tail +2;   }; f";
  "branch-commit-next" = "!f() {       branch=\"\${1:-$(git current-branch)}\";       count=\"\${2:-1}\";     git log --reverse --pretty=%H \"$branch\" |     grep -A \"$count\" $(git rev-parse HEAD) |     tail +2;   }; f";
  "refs-by-date" = "for-each-ref --sort=-committerdate --format='%(committerdate:short) %(refname:short) (objectname:short) %(contents:subject)'";
  "whois" = "!sh -c 'git log --regexp-ignore-case -1 --pretty=\"format:%an <%ae>
\" --author=\"$1\"' -";
  "whatis" = "show --no-patch --pretty='tformat:%h (%s, %ad)' --date=short";
  "who" = "shortlog --summary --numbered --no-merges";
  "issues" = "!sh -c \"git log $1 --oneline | grep -o \\\"ISSUE-[0-9]\\+\\\" | sort -u\"";
  "commit-parents" = "!f(){ git cat-file -p \"\${*:-HEAD}\" | sed -n '/0/,/^ *$/{/^parent /p}'; };f";
  "commit-is-merge" = "!f(){ [ -n \"$(git commit-parents \"$*\" | sed '0,/^parent /d')\" ];};f";
  "commit-message-key-lines" = "!f(){ echo \"Commit: $1\"; git log \"$1\" --format=fuller | grep \"^[[:blank:]]*[[:alnum:]][-[:alnum:]]*:\" | sed \"s/^[[:blank:]]*//; s/:[[:blank:]]*/: /\"; }; f";
  "initer" = "init-empty";
  "cloner" = "clone --recursive";
  "clone-lean" = "clone --depth 1 --filter=combine:blob:none+tree:0 --no-checkout";
  "snapshot" = "!git stash push --include-untracked --message \"snapshot: $(date)\" && git stash apply \"stash@{0}\" --index";
  "panic" = "!tar cvf ../panic.tar *";
  "archive" = "!f() { top=$(rev-parse --show-toplevel); cd $top; tar cvf $top.tar $top ; }; f";
  "pushy" = "!git push --force-with-lease";
  "get" = "!git fetch --prune && git pull --rebase && git submodule update --init --recursive";
  "put" = "!git commit --all && git push";
  "mainly" = "!git checkout $(git default-branch) && git fetch origin --prune && git reset --hard origin/$(git default-branch)";
  "ignore" = "!git status | grep -P \"^\\t\" | grep -vF .gitignore | sed \"s/^\\t//\" >> .gitignore";
  "push1" = "!git push origin $(git current-branch)";
  "pull1" = "!git pull origin $(git current-branch)";
  "track" = "!f(){ branch=$(git rev-parse --abbrev-ref HEAD); cmd=\"git branch $branch -u \${1:-origin}/\${2:-$branch}\"; echo $cmd; $cmd; }; f";
  "untrack" = "!f(){ branch=$(git rev-parse --abbrev-ref HEAD); cmd=\"git branch --unset-upstream \${1:-$branch}\"; echo $cmd; $cmd; }; f";
  "track-all-remote-branches" = "!f() { git branch -r | grep -v ' -> ' | sed 's/^ \\+origin\\///' ; }; f";
  "reset-commit" = "reset --soft HEAD~1";
  "reset-commit-hard" = "reset --hard HEAD~1";
  "reset-commit-hard-clean" = "!git reset --hard HEAD~1 && git clean -fd";
  "reset-to-pristine" = "!git reset --hard && git clean -ffdx";
  "reset-to-upstream" = "!git reset --hard $(git upstream-branch)";
  "undo-commit" = "reset --soft HEAD~1";
  "undo-commit-hard" = "reset --hard HEAD~1";
  "undo-commit-hard-clean" = "!git reset --hard HEAD~1 && git clean -fd";
  "undo-to-pristine" = "!git reset --hard && git clean -ffdx";
  "undo-to-upstream" = "!git reset --hard $(git upstream-branch)";
  "uncommit" = "reset --soft HEAD~1";
  "unadd" = "reset HEAD";
  "discard" = "checkout --";
  "cleaner" = "clean -dff";
  "cleanest" = "clean -dffx";
  "cleanout" = "!git clean -df && git checkout -- .";
  "expunge" = "!f() { git filter-branch --force --index-filter \"git rm --cached --ignore-unmatch $1\" --prune-empty --tag-name-filter cat -- --all }; f";
  "show-unreachable" = "!git fsck --unreachable | grep commit | cut -d\" \" -f3 | xargs git log";
  "add-cached" = "!git add $(git ls-files --cached             | sort -u)";
  "add-deleted" = "!git add $(git ls-files --deleted            | sort -u)";
  "add-others" = "!git add $(git ls-files --others             | sort -u)";
  "add-ignored" = "!git add $(git ls-files --ignored            | sort -u)";
  "add-killed" = "!git add $(git ls-files --killed             | sort -u)";
  "add-modified" = "!git add $(git ls-files --modified           | sort -u)";
  "add-stage" = "!git add $(git ls-files --stage    | cut -f2 | sort -u)";
  "add-unmerged" = "!git add $(git ls-files --unmerged | cut -f2 | sort -u)";
  "edit-cached" = "!$(git var GIT_EDITOR) $(git ls-files --cached             | sort -u)";
  "edit-deleted" = "!$(git var GIT_EDITOR) $(git ls-files --deleted            | sort -u)";
  "edit-others" = "!$(git var GIT_EDITOR) $(git ls-files --others             | sort -u)";
  "edit-ignored" = "!$(git var GIT_EDITOR) $(git ls-files --ignored            | sort -u)";
  "edit-killed" = "!$(git var GIT_EDITOR) $(git ls-files --killed             | sort -u)";
  "edit-modified" = "!$(git var GIT_EDITOR) $(git ls-files --modified           | sort -u)";
  "edit-stage" = "!$(git var GIT_EDITOR) $(git ls-files --stage    | cut -f2 | sort -u)";
  "edit-unmerged" = "!$(git var GIT_EDITOR) $(git ls-files --unmerged | cut -f2 | sort -u)";
  "ours" = "!f() { git checkout --ours   $@ && git add $@; }; f";
  "theirs" = "!f() { git checkout --theirs $@ && git add $@; }; f";
  "wip" = "!git add --all; git ls-files --deleted -z | xargs -r -0 git rm; git commit --message=wip";
  "unwip" = "!git log -n 1 | grep -q -c wip && git reset HEAD~1";
  "assume" = "update-index --assume-unchanged";
  "unassume" = "update-index --no-assume-unchanged";
  "assume-all" = "!git st -s | awk {'print $2'} | xargs -r git assume";
  "unassume-all" = "!git assumed | xargs -r git update-index --no-assume-unchanged";
  "assumed" = "!git ls-files -v | grep ^h | cut -c 3-";
  "hew" = "!git hew-local $@ && git hew-remote $@";
  "hew-dry-run" = "!git hew-local-dry-run $@ && git hew-remote-dry-run $@";
  "hew-local" = "!f() {       git hew-local-dry-run \"$@\" |       xargs git branch --delete ;   }; f \"$@\"";
  "hew-local-dry-run" = "!f() {       commit=\${1:-$(git current-branch)};       git branch --merged \"$commit\" |       grep -v \"^[[:space:]]*\\*[[:space:]]*$commit$\" ;   }; f \"$@\"";
  "hew-remote" = "!f() {       git hew-remote-dry-run \"$@\" |       xargs -I% git push origin :% 2>&1 ;   }; f \"$@\"";
  "hew-remote-dry-run" = "!f() {       commit=\${1:-$(git upstream-branch)};       git branch --remotes --merged \"$commit\" |       grep -v \"^[[:space:]]*origin/$commit$\" |       sed 's#[[:space:]]*origin/##' ;   }; f \"$@\"";
  "publish" = "!git push --set-upstream origin $(git current-branch)";
  "unpublish" = "!git push origin :$(git current-branch)";
  "inbound" = "!git remote update --prune";
  "outbound" = "log @{upstream}..";
  "reincarnate" = "!f() { [[ -n $@ ]] && git checkout \"$@\" && git unpublish && git checkout main && git branch -D \"$@\" && git checkout -b \"$@\" && git publish; }; f";
  "aliases" = "!git config --get-regexp '^alias\\.' | cut -c 7- | sed 's/ / = /'";
  "branches" = "branch -a";
  "tags" = "tag -n1 --list";
  "stashes" = "stash list";
  "top" = "rev-parse --show-toplevel";
  "default-branch" = "config init.defaultBranch";
  "current-branch" = "rev-parse --abbrev-ref HEAD";
  "upstream-branch" = "!git for-each-ref --format='%(upstream:short)' $(git symbolic-ref -q HEAD)";
  "exec" = "! exec";
  "pruner" = "!git prune --expire=now; git reflog expire --expire-unreachable=now --rewrite --all";
  "repacker" = "repack -a -d -f --depth=300 --window=300 --window-memory=1g";
  "optimizer" = "!git pruner";
  "search-commits" = "!f() { query=\"$1\"; shift; git log -S\"$query\" \"$@\"; }; f \"$@\"";
  "debug" = "!GIT_PAGER= gdb --args git";
  "diff-chunk" = "!f() {     git show \"$1:$3\" | sed -n \"/^[^ 	].*$4(/,/^}/p\" > .tmp1 ;     git show \"$2:$3\" | sed -n \"/^[^ 	].*$4(/,/^}/p\" > .tmp2 ;     git diff --no-index .tmp1 .tmp2 ;   }; f";
  "intercommit" = "!sh -c 'git show $1 > .git/commit1 && git show $2 > .git/commit2 && interdiff .git/commit[12] | less -FRS' -";
  "remotes-push" = "!git remote | xargs -I% -n1 git push %";
  "remotes-prune" = "!git remote | xargs -n 1 git remote prune";
  "cherry-pick-merge" = "!sh -c 'git cherry-pick --no-commit --mainline 1 $0 &&     git log -1 --pretty=%P $0 | cut -b 42- > .git/MERGE_HEAD &&     git commit --verbose'";
  "remote-ref" = "!sh -c '     local_ref=$(git symbolic-ref HEAD);     local_name=\${local_ref##refs/heads/};     remote=$(git config branch.\"#local_name\".remote || echo origin);     remote_ref=$(git config branch.\"$local_name\".merge);     remote_name=\${remote_ref##refs/heads/};     echo remotes/$remote/$remote_name'";
  "rebase-recent" = "!git rebase --interactive $(git remote-ref)";
  "graphviz" = "!f() { echo 'digraph git {' ; git log --pretty='format:  %h -> { %p }' \"$@\" | sed 's/[0-9a-f][0-9a-f]*/\"&\"/g' ; echo '}'; }; f";
  "serve" = "-c daemon.receivepack=true daemon --base-path=. --export-all --reuseaddr --verbose";
  "topic-base-branch" = "!git config --get init.topicBaseBranchName || git default-branch";
  "topic-begin" = "!f(){     new_branch=\"$1\";     old_branch=$(git topic-base-branch);     git checkout \"$old_branch\";     git pull --ff-only;     git checkout -b \"$new_branch\" \"$old_branch\";     git push -u origin \"$new_branch\";   };f";
  "topic-end" = "!f(){     new_branch=$(git current-branch);     old_branch=$(git topic-base-branch);     if [ \"$new_branch\" = \"$old_branch\" ]; then       printf \"You are asking to do git topic-end,
\";       printf \"but you are not on a new topic branch;
\";       printf \"you are on the base topic branch: $old_branch.
\";       printf \"Please checkout the topic branch that you want,
\";       printf \"then retry the git topic-end command.
\";     else       git push;       git checkout \"$old_branch\";       git branch --delete \"$new_branch\";       git push origin \":$new_branch\";     fi;   };f";
  "topic-sync" = "!f(){     new_branch=$(git current-branch);     old_branch=$(git topic-base-branch);     if [ \"$new_branch\" = \"$old_branch\" ]; then       printf \"You are asking to do git topic-sync,
\";       printf \"but you are not on a new topic branch;
\";       printf \"you are on the base topic branch: $old_branch.
\";       printf \"Please checkout the topic branch that you want,
\";       printf \"then retry the git topic-sync command.
\";     else       git pull;       git push;     fi;   };f";
  "topic-move" = "!f(){     new_branch=\"$1\";     old_branch=$(git current-branch);     git branch --move \"$old_branch\" \"$new_branch\";     git push origin \":$old_branch\" \"$new_branch\";   };f";
  "cvs-i" = "cvsimport -k -a";
  "cvs-e" = "cvsexportcommit -u -p";
  "gitk-conflict" = "!gitk --left-right HEAD...MERGE_HEAD";
  "gitk-history-all" = "!gitk --all $( git fsck | awk '/dangling commit/ {print $3}' )";
  "svn-b" = "svn branch";
  "svn-m" = "merge --squash";
  "svn-c" = "svn dcommit";
  "svn-cp" = "!GIT_EDITOR='sed -i /^git-svn-id:/d' git cherry-pick --edit";
}
