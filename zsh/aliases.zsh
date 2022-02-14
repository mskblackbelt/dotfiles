# Edit ZSH configuration files
alias zshconfig="$EDITOR $ZDOTDIR"
alias ohmyzsh="$EDITOR $ZSH"

# Enable sudo with aliases
alias sudo='sudo '  
# Run previous command with root privileges 
if hash thefuck 2>/dev/null; then
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
  alias brewmaint='brew update && brew outdated && brew upgrade && brew doctor'
fi
  

# UNIX tool replacements
alias more="less"

if hash exa 2>/dev/null; then
  alias ls="exa"
  alias la="exa --all --long --group --header"
fi
if hash rg 2>/dev/null; then
  alias grep="rg --color=auto"
else
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

if hash most 2>/dev/null; then
	alias less="most"
fi
if hash batcat 2>/dev/null; then 
	alias bat="batcat"
fi
if hash bat 2>/dev/null; then 
	alias cat="bat --terminal-width=-2"
fi
if hash dust 2>/dev/null; then 
	alias du="dust"
fi
if hash duf 2>/dev/null; then 
	alias df="duf"
fi
if hash fd 2>/dev/null; then 
	alias find="fd"
fi
if hash gping 2>/dev/null; then
  alias ping="gping"
elif hash prettyping 2>/dev/null; then 
	alias ping="prettyping"
fi
if hash tldr 2>/dev/null; then 
	alias help="tldr"
fi
if hash zoxide 2>/dev/null; then
  eval "$(zoxide init zsh)"
fi

# Miscellaneous aliases

if hash R 2>/dev/null; then
	alias rstat="R"
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

# Intuitive map function
# For example, to list all directories that contain a certain file:
# find . -name .gitattributes | map dirname
alias map="xargs -n1"

# Reload the shell (i.e. invoke as a login shell)
alias reload="exec $SHELL -l"
