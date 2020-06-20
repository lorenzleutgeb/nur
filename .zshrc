# Contents
#
# zsh Options
# zsh Plugins
# Setting $PATH and environment for tools
# Overrides (cat, grep)
# aliases and functions

# NOTE: Maintain symlinks:
#  - ~/src/{gh -> github.com, scl -> git.sclable.com}
#  - ~/src/gh/{ll -> lorenzleutgeb}

zmodload zsh/zprof

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
setopt HIST_IGNORE_DUPS          # Do not record an entry that was just recorded again.
#setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_SPACE         # Do not record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS         # Do not write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY               # Do not execute immediately upon history expansion.
setopt HIST_BEEP                 # Beep when accessing nonexistent history.

# Theming
export ZSH_THEME="spaceship"
# Spaceship options: https://github.com/denysdovhan/spaceship-prompt/blob/6e42f9d78a9fef0d3822d4e6b90d254ca05f1120/docs/Options.md
export SPACESHIP_CHAR_SUFFIX=""
export SPACESHIP_CHAR_SYMBOL="$ "
export SPACESHIP_CHAR_SYMBOL_ROOT="# "
export SPACESHIP_CHAR_SYMBOL_SECONDARY="… "
export SPACESHIP_TIME_SHOW="false"
export SPACESHIP_VI_MODE_SHOW="false"
export SPACESHIP_GOLANG_SHOW="false"

# Vi Mode
bindkey -v

export KEYTIMEOUT=25

autoload edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

function zle-line-init zle-keymap-select {
    RPS1="${${KEYMAP/vicmd/NORMAL}/(main|viins)/INSERT}"
    RPS2=$RPS1
    zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select

bindkey "jj" vi-cmd-mode
#bindkey -v  # instead of set -o vi
#bindkey -e jj \\e
#bindkey -M viins 'jj' vi-cmd-mode

function addp {
	PATH="$PATH:$1"
}

# Where I symlink stuff. Also, Go tooling will use it.
addp "$HOME/bin"

# MiniZinc
addp "/var/lib/snapd/snap/bin"
export MZN_STDLIB_DIR=/var/lib/snapd/snap/minizinc/current/usr/share/minizinc

# Gurobi
addp "$HOME/gurobi/bin"

# Z3
addp "$HOME/src/github.com/Z3Prover/z3/build/z3"

alias graal-env=addp "$HOME/graalvm-ce-19.2.0.1/bin"

# Google Cloud SDK
addp "$HOME/google-cloud-sdk/bin"

# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then source "$HOME/google-cloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then source "$HOME/google-cloud-sdk/completion.zsh.inc"; fi

addp "/opt/pdfover"

# According to https://golang.org/doc/install
addp "/usr/local/go/bin"

# Python tools use this
addp "$HOME/.local/bin"

addp "$HOME/gradle-5.0/bin"

# Rust
addp "$HOME/.cargo/bin"

if [ -d "$HOME/src/github.com/jenv/jenv" ]
then
	addp "$HOME/src/github.com/jenv/jenv/bin"
	addp "$HOME/.jenv/shims"
export JENV_SHELL=zsh
export JENV_LOADED=1
unset JAVA_HOME
source "$HOME/src/github.com/jenv/jenv/libexec/../completions/jenv.zsh"
jenv rehash 2>/dev/null
jenv() {
  typeset command
  command="$1"
  if [ "$#" -gt 0 ]; then
    shift
  fi

  case "$command" in
  enable-plugin|rehash|shell|shell-options)
    eval `jenv "sh-$command" "$@"`;;
  *)
    command jenv "$command" "$@";;
  esac
}
fi

ZPLUG_HOME=~/src/github.com/zplug/zplug

if [[ ! -d "$ZPLUG_HOME" ]]; then
    git clone https://github.com/zplug/zplug $ZPLUG_HOME
    source $ZPLUG_HOME/init.zsh && zplug update --self
fi

source $ZPLUG_HOME/init.zsh

zplug "mafredri/zsh-async", from:github
#zplug "sindresorhus/pure", use:pure.zsh, from:github, as:theme, on:"mafredri/zsh-async"

zplug "rupa/z", use:z.sh
zplug 'zsh-users/zsh-completions'
zplug "ael-code/zsh-colored-man-pages", from:github
zplug "zsh-users/zsh-autosuggestions", use:zsh-autosuggestions.zsh
zplug "zsh-users/zsh-syntax-highlighting", as:plugin, defer:2
zplug "zsh-users/zsh-history-substring-search", as:plugin, hook-build:"echo hi"
#zplug 'BurntSushi/ripgrep', from:gh-r, as:command, rename-to:"rg"

HISTDB_TABULATE_CMD=(sed -e $'s/\x1f/\t/g')
#zplug "larkery/zsh-histdb", use:"sqlite-history.zsh"
#autoload -Uz add-zsh-hook
#add-zsh-hook precmd histdb-update-outcome

zplug install
zplug load --verbose

if [ -f src/github.com/larkery/zsh-histdb/sqlite-history.zsh ]
then
	source src/github.com/larkery/zsh-histdb/sqlite-history.zsh
	autoload -Uz add-zsh-hook
	add-zsh-hook precmd histdb-update-outcome

# https://github.com/larkery/zsh-histdb#integration-with-zsh-autosuggestions

_zsh_autosuggest_strategy_histdb_top_here() {
    local query="select commands.argv from
history left join commands on history.command_id = commands.rowid
left join places on history.place_id = places.rowid
where places.dir LIKE '$(sql_escape $PWD)%'
and commands.argv LIKE '$(sql_escape $1)%'
group by commands.argv order by count(*) desc limit 1"
    suggestion=$(_histdb_query "$query")
}

ZSH_AUTOSUGGEST_STRATEGY=histdb_top_here
fi

export FZF_DEFAULT_COMMAND='fd'
export FZF_TMUX_HEIGHT='80%'
export FZF_COMPLETION_OPTS="--preview='batree {1}'"
export BAT_STYLE='numbers,changes'

alias cat="bat"
alias ls=exa --time-style=iso --git
alias l=exa -la --time-style=iso
alias tungz=tar xvfz

function lst {
	exa --git --tree --long --time-style=iso --level=${1:-3}
}

if [ -e /usr/share/fzf/shell/ ]
then
	source $HOME/bin/fzf-completion.zsh
	source /usr/share/fzf/shell/key-bindings.zsh
fi

function f {
	FZF_DEFAULT_COMMAND='fd' fzf-tmux
}

function ff {
	FZF_DEFAULT_COMMAND='fd -t f' fzf-tmux --delimiter=: --preview='batree {1}'
}

function cdf {
	cd $(FZF_DEFAULT_COMMAND='fd -t d' fzf-tmux --preview='batree {1}')
}
alias ducks='du -cks * | sort -rn | head'
alias online='ping -c 3 -i 0.5 -w 3 -q 8.8.8.8 > /dev/null'
alias cb='clipboard'

# Alias vim to use NeoVim
alias vim='nvim'

# If there's hub installed, alias it
if [ $(which hub) ]
then
	#alias git=hub
fi
alias g='git'
alias home="git --git-dir=$HOME/.config/home/ --work-tree=$HOME"

export PGPASSWORD="none"

export GOPATH=$HOME

export GITHUB_USER="lorenzleutgeb"

export GPG_AGENT_INFO="$HOME/.gnupg/S.gpg-agent:0:1"
export SSH_AUTH_SOCK=$HOME/.gnupg/S.gpg-agent.ssh

if [ -n "$ASCIINEMA_REC" ]; then
	PS1="$ "
fi

export SCLABLE_AUTH_KEY=$(xmlstarlet sel -t -v "/license" ~/.sclable/license.xml)

function unalias {
        name=$1
        def=$(alias $name)
        echo ${def:${#name}+2:-1}
}

function jsonfmt {
	(
	set -e
	TMP=$(mktemp --suff=jsonfmt)
	jq < $1 > $TMP
	mv $TMP $1
	unset TMP
	)
}

function jsonsort {
	(
	set -e
	TMP=$(mktemp --suff=jsonsort)
	jq -S < $1 > $TMP
	mv $TMP $1
	unset TMP
	)
}

function whichi {
	namei $(which $@)
}

function docker-recompose {
	(
docker-compose stop $1 && docker-compose rm --force $1
docker-compose up --detach --build $1
)
}

. /home/lorenz/.nix-profile/etc/profile.d/nix.sh

export SCL_BASE=$HOME/src/scl
export GH_BASE=$HOME/src/gh
export HOLDIR=$GH_BASE/HOL-Theorem-Prover/HOL
export CAKEMLDIR=$GH_BASE/$GITHUB_USER/cakeml
export CAKEML_BASIS=$CAKEMLDIR/basis

# opam configuration
test -r /home/lorenz/.opam/opam-init/init.zsh && . /home/lorenz/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true


# XDG
# https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html#variables
export XDG_CONFIG
export XDG_DATA_HOME=$HOME/.local/share
export XDG_CONFIG_HOME=$HOME/.config
export XDG_DATA_DIRS=/usr/local/share:/usr/share
export XDG_CONFIG_DIRS=/etc/xdg
export XDG_CACHE_HOME=$HOME/.cache

# Node.js
# https://github.com/nuxt/opencollective#disable-message
export OPENCOLLECTIVE_HIDE=true
export NVM_DIR="$HOME/.config/nvm"
declare -a NODE_GLOBALS=($(find $NVM_DIR/versions/node -maxdepth 3 -type l -wholename '*/bin/*' | xargs -n1 basename | sort | uniq))

NODE_GLOBALS+=("nvm")
NODE_GLOBALS+=("node")

load_nvm () {
  unset -f ${NODE_GLOBALS}
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm
  nvm use default
  if [ -f "$NVM_DIR/bash_completion" ]; then
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
  fi
}

for cmd in "${NODE_GLOBALS[@]}"; do
    eval "${cmd}(){ load_nvm; ${cmd} \$@ }"
done

[[ -s "$HOME/.avn/bin/avn.sh" ]] && source "$HOME/.avn/bin/avn.sh" # load avn
if [ -e /home/lorenz/.nix-profile/etc/profile.d/nix.sh ]; then . /home/lorenz/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
