#!/bin/bash

set -u
set -e

INSTALL_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"


install_debs() {
  echo "++ Installing debs ++"
  sudo apt-get update
  sudo apt-get install build-essential cmake python-dev exuberant-ctags nodejs zsh tmux npm fontconfig
}


install_vim() {
  echo "++ Installing vim config ++ $INSTALL_DIR"

  if [[ -d "$INSTALL_DIR/vim" ]]; then
    cd $INSTALL_DIR/vim
    git pull
  else
    git clone https://github.com/erbain/vim.git ./vim
  fi

  if [[ -e "$INSTALL_DIR/vim/bundle/vundle" ]]; then
    cd $INSTALL_DIR/vim/bundle/vundle
    git pull
  else
    git clone https://github.com/gmarik/vundle.git $INSTALL_DIR/vim/bundle/vundle
  fi

  cd $INSTALL_DIR

  if [[ -e ~/.vimrc ]]; then
    read -p ".vimrc files exists, delete it and continue? " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$  ]]; then
      echo 'Removing .vimrc file'
      rm ~/.vimrc
    else
      echo "Quit without deleting .vimrc file"
      exit
    fi
  fi

  if [[ -e ~/.vim ]]; then
    read -p ".vim folder exists, delete it and continue? " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$  ]]; then
      echo 'Reming vim folder'
      rm -Rf ~/.vim
    else
      echo "Quit without deleting .vim folder"
      exit
    fi
  fi

  ln -s $INSTALL_DIR/vim/.vimrc ~/.vimrc
  ln -s $INSTALL_DIR/vim/ ~/.vim

  # Install vundle bundles
  vim -c "execute \"BundleInstall\" | q | q"

  # Build YouCompleteMe
  cd ./vim/bundle/YouCompleteMe
  ./install.sh

  # Install tern dependencies
  cd $INSTALL_DIR
  cd ./vim/bundle/tern_for_vim
  npm install

  # Install JShint
  sudo npm install jshint -g

  cd $INSTALL_DIR
}


install_font() {
  echo "++ Installing Fonts ++"
  mkdir -p ~/.fonts
  cp $INSTALL_DIR/fonts/Inconsolata-dz\ for\ Powerline.otf ~/.fonts/
  fc-cache -vf ~/.fonts
}


install_zsh() {
  echo "++ Installing ZSH config ++"
  if [[ -d $INSTALL_DIR/zsh/oh-my-zsh ]]; then
    cd $INSTALL_DIR/zsh/oh-my-zsh
    git pull
  else
    git clone https://github.com/robbyrussell/oh-my-zsh.git $INSTALL_DIR/zsh/oh-my-zsh
    ln -si $INSTALL_DIR/zsh/oh-my-zsh ~/.oh-my-zsh
    ln -si $INSTALL_DIR/zsh/zshrc ~/.zshrc
  fi
  cp -R $INSTALL_DIR/zsh/oh-my-zsh_custom/* $INSTALL_DIR/zsh/oh-my-zsh/custom/
  echo 'stty -ixon' >> ~/.zshenv
  echo "Setting default shell to zsh"
  chsh -s /bin/zsh
}


install_i3() {
  echo "++ Installing i3 config ++"
  if [[ -d ~/.i3 ]]; then
    read -p ".i3 folder exists, delete it and continue? " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$  ]]; then
      echo 'Removing .i3 folder'
      rm -Rf ~/.i3
    else
      echo "Quit without deleting .i3 folder"
      exit
    fi
  fi
  cp -R $INSTALL_DIR/i3 ~/.i3
}


install_tmux() {
  echo "++ Installing tmux config ++"
  if [[ -e ~/.tmux.conf ]]; then
    rm ~/.tmux.conf
  fi
  if [[ ! -d ~/.tmux/plugins ]]; then
    mkdir -p ~/.tmux/plugins/
  fi
  if [[ ! -d ~/.tmux/plugins/tpm ]]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  fi

  ln -s $INSTALL_DIR/tmux/tmux.conf ~/.tmux.conf
}


#install_debs
#install_vim
#install_font
#install_zsh
#install_tmux

echo "All Done"
