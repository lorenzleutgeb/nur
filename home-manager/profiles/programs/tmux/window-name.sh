#! /usr/bin/env bash
set -eo pipefail

if ! $(git rev-parse --is-inside-work-tree)
then
	echo "?"
	exit 0
fi

GIT_TOPLEVEL=$(git rev-parse --show-toplevel)

BASE=$HOME/src
if [ "${GIT_TOPLEVEL##$BASE}" == "${GIT_TOPLEVEL}" ]
then
	echo "?"
	exit 0
fi

GIT_PREFIX=$(git rev-parse --show-prefix)

REL="${GIT_TOPLEVEL##$BASE/}"

# Standard replacements.
REL="${REL/github.com\/lorenzleutgeb/gh\/ll}"
REL="${REL/git.sclable.com\/lorenzleutgeb/scl\/ll}"
REL="${REL/github.com/gh}"
REL="${REL/git.sclable.com/scl}"

DIRN=""
if [ "$GIT_PREFIX" != "" ]
then
	# Remove trailing slash
	GIT_PREFIX=${GIT_PREFIX%"/"}
	DEPTH=${GIT_PREFIX//[!\/]}
	DEPTH=${#DEPTH}
	if [ "$DEPTH" != "0" ]
	then
	        DIRN=$(basename $GIT_PREFIX)
		DIRN=$(printf "\u208$DEPTH$DIRN\n")
	else
		DIRN="/$GIT_PREFIX"
	fi
fi

NAME="$REL$DIRN"

echo $NAME
if [ "$TMUX" != "" ]
then
	tmux rename-window $NAME
fi
