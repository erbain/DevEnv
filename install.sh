#!/bin/bash

set -u
set -e

INSTALL_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"


install_debs() {
  echo "++ Installing debs ++"
  sudo apt-get update
  sudo apt-get install build-essential cmake python-dev python3-pip exuberant-ctags nodejs zsh tmux npm fontconfig libfreetype6-dev libfontconfig1-dev xclip
}

install_alacritty() {
  echo "++ Installing alacritty ++ $INSTALL_DIR"

  curl https://sh.rustup.rs -sSf | sh
  source $HOME/.cargo/env
  rustup override set stable
  rustup update stable
  mkdir -p ~/.config/alacritty/
  ln -s $INSTALL_DIR/alacritty.yml ~/.config/alacritty/alacritty.yml
  cargo install --git https://github.com/jwilm/alacritty
}

install_nvim() {
  echo "++ Installing nvim ++ $INSTALL_DIR"
  if [[ ! -d /opt/bin ]]; then
    sudo mkdir -p /opt/bin
    sudo chown ewan /opt/bin
  fi

  pip3 install neovim
  curl -fLo /opt/bin/nvim.appimage --create-dirs \
    https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage
  chmod u+x /opt/bin/nvim.appimage
  rm -f /opt/bin/nvim
  ln -s /opt/bin/nvim.appimage /opt/bin/nvim
  if [[ ! -d ~/.config/nvim/ ]]; then
    mkdir -p ~/.config/nvim/
  fi

  rm -f ~/.config/nvim/init.vim
  ln -s $INSTALL_DIR/nvim/init.vim ~/.config/nvim/init.vim

  curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

   # Install vim-plug bundles
  /opt/bin/nvim -c "execute \"PlugInstall\" | q | q"
}

install_vim() {
  echo "++ Installing vim config ++ $INSTALL_DIR"

  if [[ -d "$INSTALL_DIR/vim" ]]; then
    cd $INSTALL_DIR/vim
    git pull
  else
    git clone https://github.com/erbain/vim.git ./vim
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
  vim -c "execute \"PlugInstall\" | q | q"

  # Install JShint
  sudo npm install jshint -g

  cd $INSTALL_DIR
}


install_font() {
  echo "++ Installing Fonts ++"
  mkdir -p ~/.fonts
  cp $INSTALL_DIR/fonts/Inconsolata\ Nerd\ Font\ Complete.otf ~/.fonts/
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


install_terminator() {
  echo "++ Installing terminator config ++"
  if [[ -e ~/.confg/terminator/config ]]; then
    rm ~/.confg/terminator/config
  fi
  if [[ ! -d ~/.confg/terminator ]]; then
    mkdir -p ~/.confg/terminator
  fi

  cp $INSTALL_DIR/terminator.config ~/.confg/terminator/config
}


#install_debs
#install_vim
#install_nvim
install_font
#install_zsh
#install_tmux
#install_terminator
