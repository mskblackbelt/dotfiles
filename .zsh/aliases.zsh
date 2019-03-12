# Edit ZSH configuration files
alias zshconfig="mate $ZDOTDIR"
alias ohmyzsh="mate $ZSH"

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


# Run hombrew maintenance functions
# Similar to 'bubu' alias in oh-my-zsh, but added brew doctor
if [[ $HAS_BREW -eq 1 ]]; then
  alias brewmaint='brew update && brew upgrade --all && brew cleanup && brew doctor'
fi
  
# Network related aliases
alias ips="ifconfig -a | perl -nle'/(\d+\.\d+\.\d+\.\d+)/ && print $1'" # Machine IPs
alias myip="curl ipinfo.io/ip" # External IP
alias flush="dscacheutil -flushcache" # Flush DNS cache
alias speedtest='wget -O /dev/null http://speedtest.wdc01.softlayer.com/downloads/test10.zip'

# Miscellaneous aliases
alias more="less"
if [[ -x $(which most) ]]; then
	alias less="most"
fi
if [[ -x $(which bat) ]]; then 
	alias cat="bat --terminal-width=-1"
fi
if [[ -x $(which prettyping) ]]; then 
	alias ping="prettyping"
fi
if [[ -x "/usr/local/bin/r" ]]; then
	alias rstat="/usr/local/bin/r"
fi
if [[ -x $(which tldr) ]]; then 
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
	
	# Force eject a volume
	# TODO create function, rather than alias?
	alias forceeject="hdiutil detach -force"
	
	# Repair the "Open with…" menu in the Finder
	alias fixopenwith="/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister -kill -r -domain local -domain user;	killall Finder; echo 'Open With has been rebuilt, Finder will relaunch'"
	# Repair the services available in the OS X share sheet
	alias fixsharesheet="/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister -kill -seed; killall Finder; echo 'Sharing services have been reseeded, check your share sheet options.'"
fi

# Hub alias created by github Oh-my-zsh plugin
if [[ -x $(which hub) ]]; then
  alias git="hub" 
fi

# Restart plasma shell
if [[ -x `which kbuildsycoca4 2> /dev/null` ]]; then
  alias plasma_restart='kbuildsycoca4 && kquitapp plasma-desktop && kstart plasma-desktop'
fi
