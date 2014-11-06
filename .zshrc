export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="frisk"
CASE_SENSITIVE="true"
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
HIST_STAMPS="yyyy-mm-dd"

plugins=(git git-extras gradle grails jira npm pyhton sudo web-search wd cake coffee command-not-found)

source $ZSH/oh-my-zsh.sh

export PATH="$HOME/bin:/opt/jdk1.8.0_11/bin:/opt/gradle-2.0/bin:/usr/local/heroku/bin:/opt/idea-IU-139.224.1/bin:/opt/go_appengine:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games"

# Fixes UTF8 on Mac OS apparently
export PYTHONIOENCODING=utf-8

alias ducks='du -cks * | sort -rn | head'
alias online='ping -c 3 -i 0.5 -w 3 -q 8.8.8.8 > /dev/null'
alias fuck='sudo !!'

# Docker and boot2 docker related stuff
# DOCKER_HOST may be unstable, let's see how it goes ...

DOCKER_HOST=tcp://192.168.59.103:2376
DOCKER_CERT_PATH=$HOME/.boot2docker/certs/boot2docker-vm
DOCKER_TLS_VERIFY=1

docker-enter() {
	boot2docker ssh '[ -f /var/lib/boot2docker/nsenter ] || docker run --rm -v /var/lib/boot2docker/:/target jpetazzo/nsenter'
	boot2docker ssh -t sudo /var/lib/boot2docker/docker-enter '$@'
}
