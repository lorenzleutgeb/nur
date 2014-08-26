export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="frisk"
CASE_SENSITIVE="true"
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
HIST_STAMPS="yyyy-mm-dd"

plugins=(git git-extras gradle grails jira npm pyhton sudo web-search wd cake coffee command-not-found)

HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

# Tell IntelliJ where it's JDK resides
export JAVA_HOME=/opt/jdk1.7.0_60

source $ZSH/oh-my-zsh.sh

export PATH=$PATH:/opt/go_appengine:/usr/local/heroku/bin:/opt/apache-tomcat-7.0.54/bin:/opt/gradle-1.12/bin:/opt/grails-2.3.6/bin:/opt/idea-IU-135.909/bin:/opt/jdk1.7.0_60/bin

bindkey '^[OH' beginning-of-line
bindkey '^[OF' end-of-line
bindkey '^[[3~' delete-char

bindkey "e[1~" beginning-of-line
bindkey "e[5~" beginning-of-history
bindkey "e[6~" end-of-history
bindkey "e[3~" delete-char
bindkey "e[2~" quoted-insert
bindkey "e[5C" forward-word
bindkey "eOc" emacs-forward-word
bindkey "e[5D" backward-word
bindkey "eOd" emacs-backward-word
bindkey "ee[C" forward-word
bindkey "ee[D" backward-word
bindkey "^H" backward-delete-word
bindkey '^i' expand-or-complete-prefix

alias ducks='du -cks * | sort -rn | head'
alias online='ping -c 3 -i 0.5 -w 3 -q 8.8.8.8 > /dev/null'