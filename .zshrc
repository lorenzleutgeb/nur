export ZSH=$HOME/.oh-my-zsh

CASE_SENSITIVE="true"
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
HIST_STAMPS="yyyy-mm-dd"

source $ZSH/oh-my-zsh.sh

plugins=(sudo lein wd z command-not-found laravel5 zsh-syntax-highlighting)

function addp {
	PATH="$PATH:$1"
}

function svn-search {
	zgrep --color --line-number $@ ~/.svn.ls.gz
}

addp "$HOME/bin"

addp "/home/lorenz/google-cloud-sdk/bin"
addp "/opt/pdfover"

# According to https://golang.org/doc/install
addp "/usr/local/go/bin"

alias ducks='du -cks * | sort -rn | head'
alias online='ping -c 3 -i 0.5 -w 3 -q 8.8.8.8 > /dev/null'
alias fuck='sudo !!'

# If there's hub installed, alias it
if [ $(which hub) ]
then
	alias git=hub
fi

export GOPATH=$HOME

export GITHUB_USER="lorenzleutgeb"

export GPG_AGENT_INFO="$HOME/.gnupg/S.gpg-agent:0:1"
export SSH_AUTH_SOCK=$HOME/.gnupg/S.gpg-agent.ssh

if [ -n "$ASCIINEMA_REC" ]; then
	PS1="$ "
fi

export SCLABLE_AUTH_KEY=$(xmlstarlet sel -t -v "/license" ~/.sclable/license.xml)

# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then source "$HOME/google-cloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then source "$HOME/google-cloud-sdk/completion.zsh.inc"; fi
