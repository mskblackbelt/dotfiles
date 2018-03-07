# Path to your oh-my-zsh configuration.
ZSH=$ZDOTDIR/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
# ZSH_THEME=""

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(battery colored-man virtualenv)


if [[ $IS_MAC -eq 1 ]]; then
    plugins=($plugins osx textmate)
	# The following plugins may slow down shell startup
	plugins=($plugins brew brew-cask)
fi

if [[ $IS_LINUX -eq 1 ]]; then
	plugins=($plugins)
fi

if [[ $HAS_APT -eq 1 ]]; then
	plugins=($plugins debian)
fi

if [[ $HAS_YUM -eq 1 ]]; then
	plugins=($plugins dnf yum)
fi	

source $ZSH/oh-my-zsh.sh
