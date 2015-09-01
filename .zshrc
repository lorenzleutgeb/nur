export ZSH=$HOME/.oh-my-zsh

GIT_CB="git::"
ZSH_THEME_SCM_PROMPT_PREFIX="%{$fg[green]%}["
ZSH_THEME_GIT_PROMPT_PREFIX=$ZSH_THEME_SCM_PROMPT_PREFIX$GIT_CB
ZSH_THEME_GIT_PROMPT_SUFFIX="]%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}*%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""

CASE_SENSITIVE="true"
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
HIST_STAMPS="yyyy-mm-dd"

plugins=(git git-extras gradle npm pyhton sudo web-search wd cake coffee command-not-found)

source $ZSH/oh-my-zsh.sh

function addp {
	PATH="$PATH:$1"
}

function svn-search {
	zgrep --color --line-number $@ ~/.svn.ls.gz
}

addp "$HOME/bin"

addp "/opt/pdfover"

# According to https://golang.org/doc/install
addp "/usr/local/go/bin"

# Fixes UTF8 on Mac OS apparently
export PYTHONIOENCODING=utf-8

alias ducks='du -cks * | sort -rn | head'
alias online='ping -c 3 -i 0.5 -w 3 -q 8.8.8.8 > /dev/null'
alias fuck='sudo !!'
alias ssh-git='gcloud compute ssh --zone europe-west1-b --ssh-key-file ~/.ssh/id_rsa lorenz_leutgeb_cod_uno@git'

if [ $(uname) = 'Darwin' ]
then
	export JAVA_HOME=$(/usr/libexec/java_home)
	launchctl setenv MATLAB_JAVA $JAVA_HOME/jre

elif [ $(uname) = 'Linux' ]
then
	export JAVA_HOME=/opt/jdk1.8.0_40
fi

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
