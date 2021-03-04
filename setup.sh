#!/usr/bin/env bash

source ~/.vars &>/dev/null
source ~/.functions &>/dev/null
source ~/.aliases &>/dev/null
source ~/.colors &>/dev/null
source ~/.shortcuts &>/dev/null

export WHO=$(whoami)

# Givin Permision to Brew/Cask
# sudo chown -R $(whoami) /usr/local/Homebrew
# sudo chown -R $(whoami) /usr/local/var/homebrew/

# List of Common Programs
# Visit for more https://formulae.brew.sh/cask/
cask_packages=(
    appcleaner
    google-chrome
    visual-studio-code
#    hyper
    postman
    slack
    spotify
    qlstephen
    webpquicklook
    xquartz
    minecraft
    1password
    adoptopenjdk
    android-sdk
    android-studio
    androidtool
    discord
    docker
    figma
    keybase
    notion
    onyx
    react-native-debugger
    runjs
    sip
    spark
    the-unarchiver
    vlc
    whatsapp
    zoom
)

# List of Packages
brew_packages=(
    zsh
    screenfetch
    git
    tree
    catimg
    "wget --with-iri"
)

# List of NPM Global Packages
npm_global_packages=(
    npm
    yarn
    serve
    firebase-tools
)

# List of Mac Default Confings
mac_defaults_configs=(
    "com.apple.screencapture location ${HOME}/Desktop/Screenshots"
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
dot_files=(
    ".aliases"
    ".vars"
    ".functions"
    ".colors"
    ".zshrc"
#    ".hyper.js"
    ".gitconfig"
)

# VSCode Extensions
vscode_extensions=(
    "aaron-bond.better-comments"
    "BenStoyer.istanbul-ignore-code-snippets"
    "bierner.color-info"
    "blairleduc.touch-bar-display"
    "bungcip.better-toml"
    "christian-kohler.path-intellisense"
    "coppy.style-hook"
    "cybai.yaml-key-viewer"
    "dinner-party-games.marshal-command-code"
    "drKnoxy.eslint-disable-snippets"
    "eamodio.gitlens"
    "EditorConfig.EditorConfig"
    "emilast.LogFileHighlighter"
#    "Equinusocio.vsc-community-material-theme"
#    "Equinusocio.vsc-material-theme"
#    "equinusocio.vsc-material-theme-icons"
#    "esbenp.prettier-vscode"
    "fabiospampinato.vscode-commands"
    "formulahendry.auto-close-tag"
    "gamunu.vscode-yarn"
    "gitduck.code-streaming"
    "golang.go"
    "jpoissonnier.vscode-styled-components"
    "kisstkondoros.vscode-gutter-preview"
    "Levertion.mcjson"
    "mhutchie.git-graph"
    "mikestead.dotenv"
    "Pivotal.vscode-manifest-yaml"
#    "PKief.material-icon-theme"
    "shakram02.bash-beautify"
    "shanoor.vscode-nginx"
    "silvenon.mdx"
    "toba.vsfire"
    "vincaslt.highlight-matching-tag"
    "VisualStudioExptTeam.vscodeintellicode"
    "wholroyd.jinja"
    "wix.vscode-import-cost"
)

# ===[ End of app list ]===

# Keep Administrator Alive
function grant_access {
    clear
    echo "${greenBold}Please, enter your password to grant root access${reset}"
    if [[ -z "${CI}" ]]; then
    sudo -v
    while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
    fi
}

# Prompt
function prompt {
    if [[ -z "${CI}" ]]; then
        echo "Type ${redBold}^C${reset} to cancel:${blueBold}"
        read -p "🖥  ${blue}${1} ...${reset}"
    fi
}

# Install
function install {
    cmd=$1
    shift
    for pkg in "$@";
    do
        exec="$cmd $pkg"
        prompt "⏳  ${yellow}Execute: ${exec}${reset}"
        if ${exec} ; then
            echo "✅  ${green}Installed ${pkg}${reset}"
        else
            echo "⛔️  ${red}Failed to execute: ${exec}${reset}"
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
            echo "${blue}Upgrading already installed package ${cyanBold}${1}${blue}... ${reset}"
            brew upgrade "$1"
        else 
            echo "${green}Latest ${1} is already installed${reset}"
        fi
    else
        brew install "$1"
    fi
}

# ===[ Menu ]===
IS_FINISHED=false

function print_menu {
    clear
    echo "$greenBold"
    echo "Choose the first step that you want to start, just enter to start from scratch."
    echo "$reset"

    echo "$purpleBold  1)$reset Install Homebrew"
    echo "$purpleBold  2)$reset Install Programs"
    echo "$purpleBold  3)$reset Install Packages"
    echo "$purpleBold  4)$reset Setup Mac Defaults"
    echo "$purpleBold  5)$reset Install Visual Studio Code Extensions"
    echo "$purpleBold  6)$reset Install Oh My ZSH"
    echo "$purpleBold  7)$reset Install Spaceship Theme"
    echo "$purpleBold  8)$reset Install Powerline Fonts"
    echo "$purpleBold  9)$reset Setup Environment"
    echo "$purpleBold 10)$reset Install ZSH Plugins"
    echo "$purpleBold 11)$reset Install NVM"
    echo "$purpleBold 12)$reset Install NPM Global Packages"
    echo "$purpleBold 13)$reset Final Setup"
    echo ""
    echo "Enter ${purpleBold}1${reset} to ${purpleBold}12${reset}. Type ${redBold}exit${reset} to cancel:${blueBold}"

    read -r OPTION

    echo "$reset"
    choicer "$OPTION"
}

function choicer {
    OPTION="$1"
    case "$OPTION" in
        1)
            install_homebrew
            ;;
        2)
            install_programs
            ;;
        3)
            install_packages
            ;;
        4)
            setup_mac_defaults
            ;;
        5)
            install_vscode_extensions
            ;;
        6)
            install_ohmyzsh
            ;;
        7)
            install_spaceship_theme
            ;;
        8)
            install_powerline_fonts
            ;;
        9)
            setup_environment
            ;;
        10)
            install_zsh_plugins
            ;;
        11)
            install_nvm
            ;;
        12)
            install_npm_globals
            ;;
        13)
            IS_FINISHED=true
            final_setup
            ;;
        "exit")
            IS_FINISHED=true
            ;;
        *)
            install_homebrew
            ;;
    esac
    ((++OPTION))

    if [ "$IS_FINISHED" = false ] ; then
        yesno_prompt
        choicer $OPTION
    fi
}

function yesno_prompt {
    read -p "Continue... (${greenBold}Y${green}es${reset}/${redBold}N${red}o${reset}): " YN
    if [[ $YN =~ ^[Nn](o)?$ ]] ; then
        exit 1
    fi
}

# ===[ Steps ]===

# 1) Install Homebrew
function install_homebrew {
    clear
    if test ! "$(command -v brew)"; then
        prompt "Install Homebrew"
        ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
        brew tap mongodb/brew
    else
        if [[ -z "${CI}" ]]; then
            prompt "Update Homebrew"
            brew update
            brew upgrade
            brew tap mongodb/brew
        fi
    fi
}

# 2) Install Programs
function install_programs {
    clear
    prompt "Install Programs"
    brew tap homebrew/cask-versions
    install 'brew install' "${cask_packages[@]}"
}

# 3) Install Packages
function install_packages {
    clear
    prompt "Install Packages"
    install 'brew install' "${brew_packages[@]}"
}

# 4) Setup Mac Defaults
function setup_mac_defaults {
    clear
    prompt "Setup Mac Defaults"

    mkdir "${HOME}/Desktop/Screenshots"
    mkdir -p /data/db

    for config in "${mac_defaults_configs[@]}"
    do
        defaults write $config
    done
    killall Finder
    killall SystemUIServer
}

# 5) Install Visual Studio Code Extensions
function install_vscode_extensions {
    clear
    prompt "Install Visual Studio Code Extensions"
    for extension in "${vscode_extensions[@]}"
    do
        code --install-extension ${extension}
    done
    cp vscode.settings.json "$HOME/Library/Application Support/Code/User/settings.json"
}

# 6) Install Oh My ZSH
function install_ohmyzsh {
    clear
    prompt "Install Oh My ZSH"
    sudo sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
}

# 7) Install Spaceship Theme
function install_spaceship_theme {
    clear
    prompt "Install Spaceship Theme"
    source ~/.zshrc
    sudo git clone https://github.com/denysdovhan/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt"
    ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"
}

# 8) Install Powerline Fonts
function install_powerline_fonts {
    clear
    prompt "Install Powerline Fonts"
    git clone https://github.com/powerline/fonts.git --depth=1
    ./fonts/install.sh
    rm -rf fonts
}

# 9) Setup Environment
function setup_environment {
    clear
    prompt "Setup Environment"
    for config in "${dot_files[@]}"
    do
        cp "${config}" "${HOME}/${config}"
        sudo chown $WHO:staff "${HOME}/${config}"
    done
}

# 10) Install ZSH Plugins
function install_zsh_plugins {
    clear
    prompt "Install ZSH Plugins"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
}

# 11) Install NVM
function install_nvm {
    clear
    prompt "Install NVM"
    curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
    exec ${SHELL} -l
    nvm 

}
# 12) Install NPM Global Packages
function install_npm_globals {
    clear
    prompt "Install NPM Global Packages"
    for npm_package in "${npm_global_packages[@]}"
    do
        npm install -g ${npm_package}
    done
}

# 13) Final Setup
function final_setup {
    clear
    prompt "Final Setup"

    su $WHO
    #sudo echo /usr/local/bin/zsh >> /etc/shells
    #chsh -s /usr/local/bin/zsh
    sudo chown $WHO:staff $HISTFILE
    sudo chown $WHO:staff /data/db
    zsh

    exec ${SHELL} -l

    echo "You to restart your computer to see the changes"
}

# ===[ Run ]===
grant_access

while :; do
    case $1 in
        -s | --step)
            choicer $2
            break;;
        *)
            print_menu
            break
    esac
    shift
done


