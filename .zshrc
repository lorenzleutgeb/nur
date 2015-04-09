export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="frisk"
CASE_SENSITIVE="true"
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
HIST_STAMPS="yyyy-mm-dd"

plugins=(git git-extras gradle grails jira npm pyhton sudo web-search wd cake coffee command-not-found)

source $ZSH/oh-my-zsh.sh

function addp {
	PATH="$PATH:$1"
}

function svn-search {
	zgrep --color --line-number $@ ~/.svn.ls.gz
}

addp "$HOME/bin"

addp "/opt/gradle-2.0/bin"
addp "/opt/apache-maven-3.2.5/bin"
addp "/opt/jdk1.8.0_25/bin"
addp "/opt/gradle-2.2.1/bin"
addp "/opt/idea-IU-139.659.2/bin"
addp "/opt/PhpStorm-139.1348/bin"
addp "/opt/go_appengine"
addp "/opt/google-cloud-sdk/bin"

# Fixes UTF8 on Mac OS apparently
export PYTHONIOENCODING=utf-8

alias ducks='du -cks * | sort -rn | head'
alias online='ping -c 3 -i 0.5 -w 3 -q 8.8.8.8 > /dev/null'
alias fuck='sudo !!'

# Docker and boot2docker related stuff
# DOCKER_HOST may be unstable, let's see how it goes ...

DOCKER_HOST=tcp://192.168.59.103:2376
DOCKER_CERT_PATH=$HOME/.boot2docker/certs/boot2docker-vm
DOCKER_TLS_VERIFY=1

if [ -n `which docker-enter 2> /dev/null` ]
	then
	docker-enter() {
		boot2docker ssh '[ -f /var/lib/boot2docker/nsenter ] || docker run --rm -v /var/lib/boot2docker/:/target jpetazzo/nsenter'
		boot2docker ssh -t sudo /var/lib/boot2docker/docker-enter '$@'
	}
fi

if [ $(uname) = 'Darwin' ]
then
	export JAVA_HOME=$(/usr/libexec/java_home)
	launchctl setenv MATLAB_JAVA $JAVA_HOME/jre

elif [ $(uname) = 'Linux' ]
then
	export JAVA_HOME='/opt/jdk1.8.0_31/'
fi

# If there's hub installed, alias it
if [ $(which hub) ]
then
	alias git=hub
fi

export GOPATH=$HOME
