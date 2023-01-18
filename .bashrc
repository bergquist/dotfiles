PS1='\[\e]0;myWindowTitle\a\]${debian_chroot:+($debian_chroot)}\u@\h:\w\$'


source ~/.bash_profile

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/carl/dev/tools/google-cloud-sdk/path.bash.inc' ]; then source '/home/carl/dev/tools/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/carl/dev/tools/google-cloud-sdk/completion.bash.inc' ]; then source '/home/carl/dev/tools/google-cloud-sdk/completion.bash.inc'; fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


export USE_GKE_GCLOUD_AUTH_PLUGIN=True
