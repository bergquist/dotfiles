#!/usr/bin/env bash

DOTFILES=~/.dotfiles

# Set my editor and git editor
if [ $(uname -s) == "MINGW32_NT-6.2" ]
then
	EDITOR="'c:/Program Files (x86)/git/bin/vim'"
	GIT_EDITOR="'c:/Program Files (x86)/git/bin/vim'"
else
	export EDITOR="/usr/bin/subl -w"
	export GIT_EDITOR='/usr/bin/vim'
fi

unset MAILCHECK # Don't check mail when opening terminal.

alias reload='source ~/.bash_profile'

if [ $(uname -s ) != "MINGW32_NT-6.2" ]
then
	source "${DOTFILES}/prompt/colors.theme.bash"
	source "${DOTFILES}/prompt/base.theme.bash"
	source "${DOTFILES}/prompt/sexy.theme.bash"
fi

PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '

for config_file in "${DOTFILES}/system/*.bash"
do
  source $config_file
done

PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
setxkbmap -option caps:ctrl_modifier


# enable bash completion in interactive shells
#if ! shopt -oq posix; then
#  if [ -f /usr/share/bash-completion/bash_completion ]; then
#    . /usr/share/bash-completion/bash_completion
#  elif [ -f /etc/bash_completion ]; then
#    . /etc/bash_completion
#  fi
#fi
