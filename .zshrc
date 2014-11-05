export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="frisk"
CASE_SENSITIVE="true"
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
HIST_STAMPS="yyyy-mm-dd"

plugins=(git git-extras gradle grails jira npm pyhton sudo web-search wd cake coffee command-not-found)

source $ZSH/oh-my-zsh.sh

export PATH="$HOME/bin:/opt/jdk1.8.0_11/bin:/opt/gradle-2.0/bin:/usr/local/heroku/bin:/opt/idea-IU-139.224.1/bin:/opt/go_appengine:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games"

alias ducks='du -cks * | sort -rn | head'
alias online='ping -c 3 -i 0.5 -w 3 -q 8.8.8.8 > /dev/null'
alias fuck='sudo !!'

