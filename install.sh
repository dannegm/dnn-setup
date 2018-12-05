#!/usr/bin/env bash

# Givin Permision to Brew/Cask
sudo chown -R $(whoami) /usr/local/Homebrew
sudo chown -R $(whoami) /usr/local/var/homebrew/

# List Of Common Programs
casks=(
  google-chrome
  visual-studio-code
  hyper
  tunnelblick
  postman
  zeplin
  slack
  skype
  spotify
  qlcolorcode
  qlstephen
  quicklook-json
  qlimagesize
  webpquicklook
  xquartz
)

# List Of Packages
brews=(
  zsh
  node
  mongodb
  nginx
  screenfetch
  git
  mysql
  Flask
  "wget --with-iri"
)

# List of Git Confings
git_configs=(
  "user.name ${dannegm}"
  "user.email ${git_email}"
  "core.editor nano"
  "core.pager cat"
)

# List of Mac Default Confings
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

# List of dotfiles
rc_files=(
  ".aliases"
  ".vars"
  ".functions"
  ".colors"
  ".zshrc"
)

# VSCode Extensions
vscode_extensions=(
  "aaron-bond.better-comments"
  "alefragnani.Bookmarks"
  "bierner.color-info"
  "blairleduc.touch-bar-display"
  "christian-kohler.path-intellisense"
  "cybai.yaml-key-viewer"
  "dariofuzinato.vue-peek"
  "EditorConfig.EditorConfig"
  "emilast.LogFileHighlighter"
  "Equinusocio.vsc-material-theme"
  "fabiospampinato.vscode-commands"
  "formulahendry.auto-close-tag"
  "formulahendry.code-runner"
  "hoovercj.vscode-power-mode"
  "humao.rest-client"
  "kisstkondoros.vscode-gutter-preview"
  "mitchdenny.ecdc"
  "ms-python.python"
  "octref.vetur"
  "paulmolluzzo.convert-css-in-js"
  "PKief.material-icon-theme"
  "shakram02.bash-beautify"
  "shanoor.vscode-nginx"
  "shyykoserhiy.vscode-spotify"
  "toba.vsfire"
  "wholroyd.jinja"
  "wix.vscode-import-cost"
)

######################################## End of app list ########################################
set +e
set -x
source ./.colors &>/dev/null

# Prompt
function prompt {
  if [[ -z "${CI}" ]]; then
    read -p "🖥  $blue $1 ...$reset"
  fi
}

# Install
function install {
  cmd=$1
  shift
  for pkg in "$@";
  do
    exec="$cmd $pkg"
    prompt "⏳  $yellow Execute: $exec $reset"
    if ${exec} ; then
      echo "✅  $green Installed $pkg $reset"
    else
      echo "⛔️  $red Failed to execute: $exec $reset"
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
      echo "$blue Upgrading already installed package $cyanBold $1 $blue ...$reset"
      brew upgrade "$1"
    else 
      echo "$green Latest $1 is already installed $reset"
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
  sudo ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
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
  sudo defaults write ${config}
done
killall Finder

# VSCode Setup
prompt "Install VSCode Extensions"
for extension in "${vscode_extensions[@]}"
do
  code --install-extension ${extension}
done

# Setup ZSH
prompt "Setup ZSH"
sudo echo /usr/local/bin/zsh >> /etc/shells && chsh -s /usr/local/bin/zsh
sudo sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Setup Spaceship
prompt "Setup Spaceship Theme"
source "~/zshrc"
sudo git clone https://github.com/denysdovhan/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt"
ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"

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
  cp "./${config}" "~/${config}"
done

# Other Plugins
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Clean Up
prompt "Cleanup"
brew cleanup
brew cask cleanup
zsh
exec ${SHELL} -l

sudo chown user:group $HISTFILE
sudo chown developer:staff $HISTFILE

echo "Done!"