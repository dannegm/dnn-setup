#!/usr/bin/env bash

# List Of Common Programs
casks=(
  google-chrome
  sublime-text
  hyper
  tunnelblick
  postman
  zeplin
  slack
  skype
  spotify
  node
  qlcolorcode
  qlstephen
  quicklook-json
  qlimagesize
  webpquicklook
  xquartz
)

# List Of Packages
brews=(
  node
  mongodb
  nginx
  screenfetch
  git
  "wget --with-iri"
)

git_configs=(
  "user.email ${dannegm}"
  "user.email ${git_email}"
  "core.editor nano"
  "core.pager cat"
)

mac_defaults_configs=(
  "com.apple.screencapture location ~/Desktop/Screenshots"
  "com.apple.finder QLEnableTextSelection -bool true"
  "com.apple.desktopservices DSDontWriteNetworkStores -bool true"
  "com.apple.desktopservices DSDontWriteUSBStores -bool true"
  "NSGlobalDomain AppleShowAllExtensions -bool true"
  "com.apple.finder ShowStatusBar -bool true"
  "com.apple.finder ShowPathbar -bool true"
  "com.apple.finder _FXSortFoldersFirst -bool true"
  "com.apple.finder FXDefaultSearchScope -string 'SCcf'"
)

rc_files=(
  ".aliases"
  ".vars"
  ".functions"
  ".zshrc"
)

######################################## End of app list ########################################
set +e
set -x

# Prompt
function prompt {
  if [[ -z "${CI}" ]]; then
    read -p "🖥 Enter to $1 ..."
  fi
}

# Install
function install {
  cmd=$1
  shift
  for pkg in "$@";
  do
    exec="$cmd $pkg"
    prompt "⏳ Execute: $exec"
    if ${exec} ; then
      echo "✅ Installed $pkg"
    else
      echo "⛔️ Failed to execute: $exec"
      if [[ ! -z "${CI}" ]]; then
        exit 1
      fi
    fi
  done
}

# Brew Function
function brew_install {
  if brew ls --versions "$1" >/dev/null; then
    if (brew outdated | grep "$1" > /dev/null); then 
      echo "Upgrading already installed package $1 ..."
      brew upgrade "$1"
    else 
      echo "Latest $1 is already installed"
    fi
  else
    brew install "$1"
  fi
}

# Keep Administrator Alive
if [[ -z "${CI}" ]]; then
  sudo -v
  while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
fi

# Seeking for Brew/Cask
if test ! "$(command -v brew)"; then
  prompt "Install Homebrew"
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
  if [[ -z "${CI}" ]]; then
    prompt "Update Homebrew"
    brew update
    brew upgrade
    brew doctor
  fi
fi
export HOMEBREW_NO_AUTO_UPDATE=1

# Installing Software
prompt "Install software"
brew tap caskroom/versions
install 'brew cask install' "${casks[@]}"

prompt "Install packages"
install 'brew_install' "${brews[@]}"

# NVM
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
# MongoDB
sudo mkdir -p /data/db

# GIT Setup
prompt "Set GIT defaults"
for config in "${git_configs[@]}"
do
  git config --global ${config}
done

# Mac Setup
prompt "Set Mac defaults"
for config in "${mac_defaults_configs[@]}"
do
  defaults write ${config}
done
killall Finder

# Setup ZSH
prompt "Setup ZSH"
brew install zsh
sudo -s 'echo /usr/local/bin/zsh >> /etc/shells' && chsh -s /usr/local/bin/zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

read -p "Do you want to switch to ZSH promt? (y/n)" yn
if [$yn="${yn#[Yy]}"]; then
  zsh
fi

# Setup Spaceship
prompt "Setup Spaceship Theme"
source "~/zshrc"
git clone https://github.com/denysdovhan/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt"

# Setup Powerline Fonts
prompt "Setup Powerline Fonts"
git clone https://github.com/powerline/fonts.git --depth=1
cd fonts
./install.sh
cd ..
rm -rf fonts

# Setup Profile
prompt "Set ZSH Configs"
for config in "${rc_files[@]}"
do
  mv "./${config}" "~/${config}"
  source "~/${config}"
done

# Clean Up
prompt "Cleanup"
brew cleanup
brew cask cleanup

echo "Done!"