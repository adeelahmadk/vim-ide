#!/usr/bin/env bash
wrapper() {
  RED="\033[0;31m"
  GREEN="\033[0;32m"
  YELLOW="\033[0;33m"
  BLUE="\033[0;36m"
  NORMAL="\033[0m"

  REPO_HTTPS="https://github.com/cod3g3nki/vim-ide.git"
  FONT_HTTPS="https://raw.githubusercontent.com/powerline/fonts/master/UbuntuMono/Ubuntu%20Mono%20derivative%20Powerline.ttf"
  VUNDLE_HTTPS="https://github.com/VundleVim/Vundle.vim.git"

echo "${BLUE}"
cat << "HELLO_TEXT"
                    _
                   (_)
             __   ___ _ __ ___  _ __ ___
             \ \ / / | '_ ` _ \| '__/ __|
              \ V /| | | | | | | | | (__
               \_/ |_|_| |_| |_|_|  \___|

Special thanks to: ets-labs [https://github.com/ets-labs]
HELLO_TEXT
echo "${NORMAL}"
echo
echo
printf "${GREEN}%s${NORMAL}\n" "Dependency:"
printf "${BLUE}%s${NORMAL}\n" "  -Exuberant Ctags"
echo
echo

  if [ ! -n "$VIM" ]; then
    VIM=~/.vim
  fi

  if [ ! -n "$LOCAL" ]; then
    LOCAL=~/.local/share
  fi

 if [ -d "$VIM" ]; then
    printf "${YELLOW}%s${NORMAL}\n" "You already have $VIM directory."
    printf "${YELLOW}%s${NORMAL}\n" "You have to remove $VIM if you want to re-install."
    exit 0
  fi

  # Prevent the cloned repository from having insecure permissions. Failing to do
  # so causes compinit() calls to fail with "command not found: compdef" errors
  # for users with insecure umasks (e.g., "002", allowing group writability). Note
  # that this will be ignored under Cygwin by default, as Windows ACLs take
  # precedence over umasks except for filesystems mounted with option "noacl".
  #umask g-w,o-w

  printf "${BLUE}%s${NORMAL}\n" "Cloning vimrc from ${REPO_HTTPS}"

  hash git >/dev/null 2>&1 || {
    printf "${RED}%s${NORMAL}\n" "Error: git is not installed."
    exit 1
  }

  env git clone --depth=1 $REPO_HTTPS $VIM || {
    printf "${RED}%s${NORMAL}\n" "Error: git clone of vimrc repo failed."
    exit 1
  }

  printf "${BLUE}%s${NORMAL}\n" "Looking for an existing vim config..."
  if [ -f ~/.vimrc ] || [ -h ~/.vimrc ]; then
    printf "${YELLOW}%s${NORMAL}\n" "Found ~/.vimrc."
    printf "${BLUE}%s${NORMAL}\n" "You will see your old ~/.vimrc as $VIM/vimrc.bak"
    mv ~/.vimrc $VIM/vimrc.bak
  fi

  printf "${BLUE}%s${NORMAL}\n" "Symlinking $VIM/vimrc with ~/.vimrc..."
  ln -fs $VIM/vimrc ~/.vimrc

  if [ ! -d "$VIM/bundle/Vundle.vim" ]; then
      printf "${BLUE}%s${NORMAL}\n" "Installing Vundle..."
      env git clone --depth=1 $VUNDLE_HTTPS "$VIM/bundle/Vundle.vim"
  fi

  if [ ! -f $VIM/colors/wombat256mod.vim ]; then
      if [ ! -d $VIM/colors/ ]; then
          mkdir -p $VIM/colors
      fi
      wget 'http://www.vim.org/scripts/download_script.php?src_id=13400' -O $VIM/colors/wombat256mod.vim
  fi

  if [ ! -f $LOCAL/fonts/wUbuntu\ Mono\ derivative\ Powerline.ttf ]; then
      if [ ! -d $LOCAL/fonts ]; then
          mkdir -p $LOCAL/fonts
      fi
      wget 'https://raw.githubusercontent.com/powerline/fonts/master/UbuntuMono/Ubuntu%20Mono%20derivative%20Powerline.ttf' -O $LOCAL/fonts/Ubuntu\ Mono\ derivative\ Powerline.ttf
  fi


  printf "${GREEN}%s${NORMAL}\n" "Vimrc has been configured ;)"
  printf "${YELLOW}%s${NORMAL}\n" "Do not worry about error messages. When it occurs just press enter and wait till all plugins are installed."
  printf "${BLUE}%s${NORMAL}\n" "Keep calm and fly VIM!"
}

wrapper
vim +PluginInstall
