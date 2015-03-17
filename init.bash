if [ $(uname -s ) != "MINGW32_NT-6.2" ]
then
	source "${DOTFILES}/prompt/colors.theme.bash"
	source "${DOTFILES}/prompt/base.theme.bash"
	source "${DOTFILES}/prompt/sexy.theme.bash"
fi

LIB="${DOTFILES}/system/*.bash"
for config_file in $LIB
do
  source $config_file
done

