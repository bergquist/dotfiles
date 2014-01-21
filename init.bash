source "${DOTFILES}/prompt/colors.theme.bash"
source "${DOTFILES}/prompt/base.theme.bash"
source "${DOTFILES}/prompt/sexy.theme.bash"

#for source in `find $DOTFILES -maxdepth 2 -name \*.bash`
#  do
#    dest="$HOME/.`basename \"${source%.*}\"`"
#  done
#}

LIB="${DOTFILES}/system/*.bash"
for config_file in $LIB
do
  source $config_file
done
