# Edit ZSH configuration files
alias zshconfig="$EDITOR $ZDOTDIR"
alias ohmyzsh="$EDITOR $ZSH"

# Enable sudo with aliases
alias sudo='sudo '  
# Run previous command with root privileges 
if [[ -x $(which thefuck) ]]; then
  eval "$(thefuck --alias)"
else
  alias fuck='sudo $(fc -ln -1)'
fi

# Show history
alias history='fc -l 1'

# Inline calculator alias
alias calc='noglob __calc_plugin'

# Run hombrew maintenance functions
# Similar to 'bubu' alias in oh-my-zsh, but added brew doctor
if [[ $HAS_BREW -eq 1 ]]; then
  alias brewmaint='brew update && brew outdated && brew upgrade --all && brew cleanup && brew doctor'
fi
  

# Miscellaneous aliases
alias more="less"
if [[ -x $(which most 2> /dev/null) ]]; then
	alias less="most"
fi
if [[ -x $(which bat 2> /dev/null) ]]; then 
	alias cat="bat --terminal-width=-2"
fi
if [[ -x $(which prettyping 2> /dev/null) ]]; then 
	alias ping="prettyping"
fi
if [[ -x "/usr/local/bin/r" ]]; then
	alias rstat="/usr/local/bin/r"
fi
if [[ -x $(which tldr 2> /dev/null) ]]; then 
	alias help="tldr"
fi


# -------------------------------------------------------------------
# Folder aliases
# -------------------------------------------------------------------
hash -d dl=~/Downloads
hash -d doc=~/Documents
hash -d dev=~/Projects
hash -d dt=~/Desktop
hash -d icloud=~/iCloud\ Drive

# -------------------------------------------------------------------
# Mac only
# -------------------------------------------------------------------
if [[ $IS_MAC -eq 1 ]]; then
	alias ql="quick-look"
	alias pman="man-preview"
	if [[ -x '/Applications/Mathematica.app/contents/MacOS/MathKernel' ]]; then 
		alias math='/Applications/Mathematica.app/contents/MacOS/MathKernel'
	fi

	
	# -------------------------------------------------------------------
	# Collection of aliases from matias bynens dotfiles
	# -------------------------------------------------------------------

	# PlistBuddy alias, because sometimes `defaults` just doesn’t cut it
	alias plistbuddy="/usr/libexec/PlistBuddy"

	# Ring the terminal bell, and put a badge on Terminal.app’s Dock icon
	# (useful when executing time-consuming commands)
	alias badge="tput bel"

	
fi

# Hub alias created by github Oh-my-zsh plugin
if [[ -x $(which hub) ]]; then
  alias git="hub" 
fi

# Intuitive map function
# For example, to list all directories that contain a certain file:
# find . -name .gitattributes | map dirname
alias map="xargs -n1"

# Reload the shell (i.e. invoke as a login shell)
alias reload="exec $SHELL -l"
