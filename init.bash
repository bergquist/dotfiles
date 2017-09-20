if [ $(uname -s ) != "MINGW32_NT-6.2" ]
then
	source "${DOTFILES}/prompt/colors.theme.bash"
	source "${DOTFILES}/prompt/base.theme.bash"
	source "${DOTFILES}/prompt/sexy.theme.bash"
fi

PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '

LIB="${DOTFILES}/system/*.bash"
for config_file in $LIB
do
  source $config_file
done

PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '

