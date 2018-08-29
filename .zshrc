# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

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

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"  # This loads nvm bash_completion