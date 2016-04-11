export ZSH=$HOME/.oh-my-zsh

CASE_SENSITIVE="true"
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
HIST_STAMPS="yyyy-mm-dd"

plugins=(sudo wd command-not-found zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

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

# https://github.com/nvbn/thefuck
# sudo pip install thefuck
alias fuck='eval $(thefuck $(fc -ln -1))'

export GOPATH=$HOME

alias docker-fetch="sudo wget https://master.dockerproject.org/linux/amd64/docker -O /usr/bin/docker; sudo chmod 755 /usr/bin/docker"

export GITHUB_USER="flowlo"

alias gupu="ssh lp gupu -geometry 512x128 -font '*-iso8859-1'"

export GPG_AGENT_INFO="$HOME/.gnupg/S.gpg-agent:0:1"
export SSH_AUTH_SOCK=$HOME/.gnupg/S.gpg-agent.ssh

if [ -n "$ASCIINEMA_REC" ]; then
	PS1="$ "
fi

alias mdv="~/src/github.com/axiros/terminal_markdown_viewer/mdv.py"
