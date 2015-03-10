# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="af-magic"

# Customize to your needs...
eval `/usr/libexec/path_helper -s`
export PATH=$HOME/bin:$PATH:$HOME/.cabal/bin:/usr/local/opt/ruby/bin:$HOME/.gem/ruby/2.0.0/bin

# Enable ZSH completion
fpath=(/usr/local/share/zsh-completions $fpath)

# Enable ZSH syntax highlighting
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Python paths
export PYTHONPATH=$PYTHONPATH
export WORKON_HOME=$HOME/.virtualenvs

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)

plugins=(brew brew-cask colored-man colorize compleat history osx pip python rand-quote textmate pyenv virtualenv virtualenvwrapper)

source $ZSH/oh-my-zsh.sh

export GNUTERM='X11'
export EDITOR='mate -w'
export PAGER='most'
export TEXEDIT='mate -w -l %d "%s"'
export HOMEBREW_GITHUB_API_TOKEN=''

# Move these lines to a .pyconfig file inside the .dotfiles folder
# Python setup
if [ -f /usr/local/bin/virtualenvwrapper.sh ]; then
    source /usr/local/bin/virtualenvwrapper.sh
fi
# Auto-activate and enable pyenv and shims
if which pyenv > /dev/null; then
  eval "$(pyenv init -)"
fi
# Auto-activate pyenv-virtualenv
if which pyenv-virtualenv-init > /dev/null; then
  eval "$(pyenv virtualenv-init -)"
fi
# Set pyenv home to homebrew directories
export PYENV_ROOT=/usr/local/opt/pyenv
# pip should only run if there is a virtualenv currently activated
export PIP_REQUIRE_VIRTUALENV=true
# cache pip-installed packages to avoid re-downloading
export PIP_DOWNLOAD_CACHE=$HOME/.pip/cache
# use pyenv instead of virtualenv for management of virtualenvs
export PYENV_VIRTUALENVWRAPPER_PREFER_PYVENV="true"
# To install pip packages systemwide, use the following:
syspip(){
   PIP_REQUIRE_VIRTUALENV="" pip "$@"
}
syspip3(){
   PIP_REQUIRE_VIRTUALENV="" pip3 "$@"
}
alias virtualenv3="virtualenv -p python3"

#Autoload modules
autoload -U zcalc
[[ -e $(alias run-help) ]] && unalias run-help
autoload run-help
HELPDIR=/usr/local/share/zsh/helpfiles

# Uncomment to disable autocorrect for all commands
# unsetopt correct_all

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how many often would you like to wait before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"

# Prevents C-d from trigering end-of-file and exiting terminal
setopt ignore_eof

# Example aliases
alias zshconfig="mate ~/.zshrc"
alias ohmyzsh="mate ~/.oh-my-zsh"

# Enable sudo with aliases
alias sudo='sudo '  
# Run previous command with root privileges. 
alias fuck='sudo $(fc -ln -1)'

# Show history
alias history='fc -l 1'

alias fixopenwith='/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister -kill -r -domain local -domain user; killall Finder; open -a Path\ Finder; echo "Open With has been rebuilt, Finder will relaunch"'

alias forceeject="hdiutil detach -force"
alias speedtest='wget -O /dev/null http://speedtest.wdc01.softlayer.com/downloads/test10.zip'
alias brewmaint='brew update && brew upgrade && brew doctor'

# Get readable list of network IPs
alias ips="ifconfig -a | perl -nle'/(\d+\.\d+\.\d+\.\d+)/ && print $1'" # Machine IPs
alias myip="dig +short myip.opendns.com @resolver1.opendns.com" # External IP
alias flush="dscacheutil -flushcache" # Flush DNS cache

# Miscellaneous aliases (Should move to .aliases file for easier control… though zshconfig won't work for editing then. Could create a 'dotconfig' alias that opens the whole folder in TextMate.)
alias htop="xterm -geometry 130x40 htop &"
# alias most="nocorrect most"
alias more="most"
alias less="most"
alias ql="quick-look"
alias pman="man-preview"
alias math="/Applications/Mathematica\ 10.app/contents/MacOS/MathKernel"
alias rstat="/usr/local/bin/r"

# Hub alias created by github Oh-my-zsh plugin
# alias git="hub" 

# Misc. functions to extend OS X application control
# quit running application
quit () {
    for app in $*; do
        osascript -e 'quit app "'$app'"'
    done
}

# relaunch application
relaunch () {
    for app in $*; do
        osascript -e 'quit app "'$app'"';
        sleep 2;
        open -a $app
    done
}
