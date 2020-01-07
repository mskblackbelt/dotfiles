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
  
# Network related aliases
alias ips="ifconfig -a | perl -nle'/(\d+\.\d+\.\d+\.\d+)/ && print $1'" # Machine IPs
alias myip="curl ipinfo.io/ip" # External IP
alias flush="dscacheutil -flushcache" # Flush DNS cache
alias speedtest='wget -O /dev/null http://speedtest.wdc01.softlayer.com/downloads/test10.zip'

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
	
	# Force eject a volume
	# TODO create function, rather than alias?
	alias forceeject="hdiutil detach -force"
	
	# Repair the "Open with…" menu in the Finder
	alias fixopenwith="/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/\
		LaunchServices.framework/Versions/A/Support/lsregister -kill -r -domain local -domain user; \
			killall Finder; echo 'Open With has been rebuilt, Finder will relaunch'"
	# Repair the services available in the OS X share sheet
	alias fixsharesheet="/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/\
		LaunchServices.framework/Versions/A/Support/lsregister -kill -seed; killall Finder; \
			echo 'Sharing services have been reseeded, check your share sheet options.'"
	
	# -------------------------------------------------------------------
	# Collection of aliases from matias bynens dotfiles
	# -------------------------------------------------------------------

	# Hide/show all desktop icons (useful when presenting)
	alias hidedesktop="defaults write com.apple.finder CreateDesktop -bool false && killall Finder"
	alias showdesktop="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"

	# Merge PDF files
	# Usage: `mergepdf -o output.pdf input{1,2,3}.pdf`
	alias mergepdf='/System/Library/Automator/Combine\ PDF\ Pages.action/Contents/Resources/join.py'

	# Disable Spotlight
	alias spotoff="sudo mdutil -a -i off"
	# Enable Spotlight
	alias spoton="sudo mdutil -a -i on"

	# PlistBuddy alias, because sometimes `defaults` just doesn’t cut it
	alias plistbuddy="/usr/libexec/PlistBuddy"

	# Ring the terminal bell, and put a badge on Terminal.app’s Dock icon
	# (useful when executing time-consuming commands)
	alias badge="tput bel"

	# Lock the screen (when going AFK)
	alias afk="/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend"
	
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
