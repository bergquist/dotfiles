#!/usr/bin/env bash

DOTFILES=~/.dotfiles

set -e
echo ''

#helper functions
info () {
  printf "  [ \033[00;34m..\033[0m ] $1\n"
}

user () {
  printf "\r  [ \033[0;33m?\033[0m ] $1\n"
}

success () {
  printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

fail () {
  printf "\r\033[2K  [\033[0;31mFAIL\033[0m] $1\n"
  echo ''
  exit
}

link_files () {
  ln -s $1 $2
  success "linked $1 to $2"
}

#setup bash_profile file
test -w $HOME/.bash_profile &&
  mv $HOME/.bash_profile $HOME/.bash_profile.bak &&
  info "Your original .bash_profile has been backed up to .bash_profile.bak"

cp $DOTFILES/templates/bash_profile.template $HOME/.bash_profile
info "Copied the template .bash_profile into ~/.bash_profile, edit this file to customize bash-it"

#should this be symlinked instead?

#setup gitconfig
setup_gitconfig () {
  if ! [ -f git/gitconfig.symlink ]
  then
    info 'setup gitconfig'

    user ' - What is your github author name?'
    read -e git_authorname
    user ' - What is your github author email?'
    read -e git_authoremail

    sed -e "s/AUTHORNAME/$git_authorname/g" -e "s/AUTHOREMAIL/$git_authoremail/g" git/gitconfig.symlink.example > git/gitconfig.symlink

    success 'gitconfig'
  fi
}

setup_gitconfig

#setup symlinks
install_dotfiles () {
  info 'installing dotfiles'

  overwrite_all=false
  backup_all=false
  skip_all=false

  for source in `find $DOTFILES -maxdepth 2 -name \*.symlink`
  do
    dest="$HOME/.`basename \"${source%.*}\"`"

    if [ -f $dest ] || [ -d $dest ]
    then

      overwrite=false
      backup=false
      skip=false

      if [ "$overwrite_all" == "false" ] && [ "$backup_all" == "false" ] && [ "$skip_all" == "false" ]
      then
        user "File already exists: `basename $source`, what do you want to do? [s]kip, [S]kip all, [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all?"
        read -n 1 action

        case "$action" in
          o )
            overwrite=true;;
          O )
            overwrite_all=true;;
          b )
            backup=true;;
          B )
            backup_all=true;;
          s )
            skip=true;;
          S )
            skip_all=true;;
          * )
            ;;
        esac
      fi

      if [ "$overwrite" == "true" ] || [ "$overwrite_all" == "true" ]
      then
        rm -rf $dest
        success "removed $dest"
      fi

      if [ "$backup" == "true" ] || [ "$backup_all" == "true" ]
      then
        mv $dest $dest\.backup
        success "moved $dest to $dest.backup"
      fi

      if [ "$skip" == "false" ] && [ "$skip_all" == "false" ]
      then
        link_files $source $dest
      else
        success "skipped $source"
      fi

    else
      link_files $source $dest
    fi

  done
}

install_dotfiles

#run homebrew
if [ "$(uname -s)" == "Darwin" ]
then
  info "installing dependencies"
  if . bin/dot > /tmp/dotfiles-dot 2>&1
  then
    success "dependencies installed"
  else
    fail "error installing dependencies"
  fi
fi

echo ''
echo '  All installed!'