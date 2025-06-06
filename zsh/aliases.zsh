# Edit ZSH configuration files
alias zshconfig="$EDITOR $(readlink $ZDOTDIR)"
alias ohmyzsh="$EDITOR $(readlink $ZSH)"

# Enable sudo with aliases
alias sudo='sudo '  
# Run previous command with root privileges 
if _command_exists thefuck; then
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
  alias brewmaint='brew update && brew outdated && brew upgrade && brew cleanup && brew doctor'
fi
  

# UNIX tool replacements
alias more="less"

if _command_exists eza; then
  alias ls="eza"
  alias la="eza --all --long --group --header --git --icons=automatic"
fi

if _command_exists rg; then
  alias grep="rg --color=auto"
else
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

# if _command_exists most; then
# 	alias less="most"
# fi
if _command_exists batcat; then 
	alias bat="batcat"
	alias cat="bat --terminal-width=-2"
	# alias -g -- -h='-h 2>&1 | bat --language=help --style=plain'
	alias -g -- --help='--help 2>&1 | bat --language=help --style=plain'
fi

if _command_exists bat; then 
	alias cat="bat --terminal-width=-2"
	alias -g -- -h='-h 2>&1 | bat --language=help --style=plain'
	alias -g -- --help='--help 2>&1 | bat --language=help --style=plain'
fi
if _command_exists dust; then 
	alias du="dust"
fi
if _command_exists duf; then 
	alias df="duf"
fi
if _command_exists fd; then 
	alias find="fd"
fi
if _command_exists gping; then
  alias ping="gping"
elif _command_exists prettyping; then 
  alias ping="prettyping"
fi
if _command_exists tldr; then 
	alias help="tldr"
else 
	alias help="man"
fi
if _command_exists zoxide; then
  eval "$(zoxide init zsh --cmd cd)"
fi

# Miscellaneous aliases

if _command_exists R; then
	alias rstat="R"
fi

# -------------------------------------------------------------------
# Folder aliases
# -------------------------------------------------------------------
hash -d dl=~/Downloads
hash -d doc=~/Documents
hash -d dt=~/Desktop
if [[ -d $HOME/iCloud\ Drive ]]; then 
  hash -d icloud=~/iCloud\ Drive
fi
if [[ -d $HOME/Developer ]]; then
  hash -d dev=~/Developer
elif [[ -d $HOME/Projects ]]; then
  hash -d dev=~/Projects
fi


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
