source "${DOTFILES}/prompt/colors.theme.bash"
source "${DOTFILES}/prompt/base.theme.bash"
source "${DOTFILES}/prompt/sexy.theme.bash"

LIB="${DOTFILES}/system/*.bash"
for config_file in $LIB
do
  source $config_file
done
