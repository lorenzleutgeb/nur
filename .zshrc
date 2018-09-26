export ZSH=$HOME/.oh-my-zsh
source $ZSH/oh-my-zsh.sh

export CASE_SENSITIVE="true"
export ENABLE_CORRECTION="true"
export COMPLETION_WAITING_DOTS="true"
export HIST_STAMPS="yyyy-mm-dd"

# Tuning history
HISTFILE="$HOME/.zsh_history"
HISTSIZE=2147483647
SAVEHIST=2147483647
setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY               # Don't execute immediately upon history expansion.
setopt HIST_BEEP                 # Beep when accessing nonexistent history.

plugins=(sudo lein wd command-not-found zsh-syntax-highlighting)

function addp {
	PATH="$PATH:$1"
}

# Legacy from Catalysts
# function svn-search {
# 	zgrep --color --line-number $@ ~/.svn.ls.gz
# }

# Where I symlink stuff. Also, the Golang tooling will use it.
addp "$HOME/bin"

# MiniZinc
addp "$HOME/MiniZincIDE-2.1.6-bundle-linux-x86_32"
export MZN_STDLIB_DIR=~/MiniZincIDE-2.1.6-bundle-linux-x86_32/share/minizinc

addp "$HOME/graalvm-1.0.0-rc1/bin"

# Google Cloud SDK
addp "$HOME/google-cloud-sdk/bin"
# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then source "$HOME/google-cloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then source "$HOME/google-cloud-sdk/completion.zsh.inc"; fi

addp "/opt/pdfover"

# According to https://golang.org/doc/install
addp "/usr/local/go/bin"

# Pyhton tools use this
addp "$HOME/.local/bin"

alias ducks='du -cks * | sort -rn | head'
alias online='ping -c 3 -i 0.5 -w 3 -q 8.8.8.8 > /dev/null'
alias fuck='sudo !!'

# If there's hub installed, alias it
if [ $(which hub) ]
then
	alias git=hub
fi

export PGPASSWORD="none"

export GOPATH=$HOME

export GITHUB_USER="lorenzleutgeb"

export GPG_AGENT_INFO="$HOME/.gnupg/S.gpg-agent:0:1"
export SSH_AUTH_SOCK=$HOME/.gnupg/S.gpg-agent.ssh

if [ -n "$ASCIINEMA_REC" ]; then
	PS1="$ "
fi

export SCLABLE_AUTH_KEY=$(xmlstarlet sel -t -v "/license" ~/.sclable/license.xml)

alias gotty-tmux="gotty -w tmux new -A -s gotty $SHELL"
alias tmux-gotty="tmux new -A -s gotty"

function unalias {
        name=$1
        def=$(alias $name)
        echo ${def:${#name}+2:-1}
}


function tilix-gotty {
	tilix -a session-add-right -e "ngrok start gotty"
	tilix -a session-add-down -e "$(unalias gotty-tmux)"
	tmux-gotty
}

function jsonfmt {
	(
	set -e
	TMP=$(mktemp --suff=jsonfmt)
	cp -v $1 $TMP
	python3 -m json.tool $TMP > $1
	rm -v $TMP
	)
}

# NOTE: Maintain symlinks:
#  - ~/src/{gh -> github.com, scl -> git.sclable.com}
#  - ~/src/gh/{ll -> lorenzleutgeb}
export SCL_BASE=$HOME/src/scl
export GH_BASE=$HOME/src/gh
export HOLDIR=$GH_BASE/HOL-Theorem-Prover/HOL
export CAKEMLDIR=$GH_BASE/$GITHUB_USER/cakeml
export CAKEML_BASIS=$CAKEMLDIR/basis

# opam configuration
test -r /home/lorenz/.opam/opam-init/init.zsh && . /home/lorenz/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true

# For managing Node.js versions:
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

