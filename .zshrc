# SHELL/ZSH Setup

export ZSH=/Users/developer/.oh-my-zsh
ZSH_THEME="spaceship"

# Plugins
plugins=(
  git docker encode64 httpie osx zsh-syntax-highlighting history web-search colored-man-pages
)

# Sources
source $ZSH/oh-my-zsh.sh
source ~/.vars
source ~/.functions
source ~/.aliases
source ~/.colors
source ~/.shortcuts
