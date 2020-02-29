#!/usr/bin/env bash

DOTFILES=~/.dotfiles

export EDITOR="/usr/bin/vim"
export GIT_EDITOR='/usr/bin/vim'

unset MAILCHECK # Don't check mail when opening terminal.

alias reload='source ~/.bash_profile'

source "${DOTFILES}/prompt/colors.theme.bash"
source "${DOTFILES}/prompt/base.theme.bash"
source "${DOTFILES}/prompt/sexy.theme.bash"

source "${DOTFILES}/system/aliases.bash"
source "${DOTFILES}/system/config.bash"
source "${DOTFILES}/system/docker.bash"
source "${DOTFILES}/system/golang.bash"
source "${DOTFILES}/system/google-cloud.bash"
source "${DOTFILES}/system/path.bash"
source "${DOTFILES}/system/python.bash"


# Autocorrect typos in path names when using `cd`
shopt -s cdspell

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob

PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
#setxkbmap -option caps:ctrl_modifier
#setxkbmap -option ctrl:nocaps

# Syntax-highlight JSON strings or files
# Usage: `json '{"foo":42}'` or `echo '{"foo":42}' | json`
json() {
	if [ -t 0 ]; then # argument
		python -mjson.tool <<< "$*" | pygmentize -l javascript
	else # pipe
		python -mjson.tool | pygmentize -l javascript
	fi
}

eval "$(hub alias -s)"

# include timestamp in bash history
HISTTIMEFORMAT="%F %T "

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


# enable bash completion in interactive shells
#if ! shopt -oq posix; then
#  if [ -f /usr/share/bash-completion/bash_completion ]; then
#    . /usr/share/bash-completion/bash_completion
#  elif [ -f /etc/bash_completion ]; then
#    . /etc/bash_completion
#  fi
#fi
