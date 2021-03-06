# SHELL/ZSH Setup

export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="spaceship"

# Plugins
plugins=(
  git docker encode64 httpie osx zsh-syntax-highlighting zsh-autosuggestions history web-search colored-man-pages
)

# Sources
source $ZSH/oh-my-zsh.sh
source ~/.vars
source ~/.functions
source ~/.aliases
source ~/.colors
source ~/.shortcuts
