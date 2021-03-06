function zsh_recompile {
  autoload -U zrecompile
  rm -f $ZSH/**/*.zwc
  [[ -f ~/.zshrc ]] && zrecompile -p ~/.zshrc
  [[ -f ~/.zshrc.zwc.old ]] && rm -f ~/.zshrc.zwc.old

  for f in $ZSH/**/*.zsh; do
    [[ -f $f ]] && zrecompile -p $f
    [[ -f $f.zwc.old ]] && rm -f $f.zwc.old
  done

  [[ -f ~/.zcompdump* ]] && zrecompile -p ~/.zcompdump
  [[ -f ~/.zcompdump*.zwc.old ]] && rm -f ~/.zcompdump*.zwc.old

  source ~/.zshrc
}

# Wrapper for zsh function information
zinfo() {info --index-search="$*" zsh}

# calculator plugin, aliases assigned in `aliases.zsh`
function __calc_plugin {
    zcalc -e "$*"
}

# Network related functions
function ips () {
  ifconfig -a | perl -nle'/(\d+\.\d+\.\d+\.\d+)/ && print $1' # Machine IPs
  }
  
function myip () {
  curl ipinfo.io/ip # External IP
  }

function flush () {
  dscacheutil -flushcache # Flush DNS cache
  }
  
function speedtest () {
  if (( $# == 0 ))
    then wget -O /dev/null "http://speedtest.wdc01.softlayer.com/downloads/test10.zip"; 
  fi
  for i; 
    do wget -O /dev/null "http://speedtest.wdc01.softlayer.com/downloads/test$i.zip";
  done
}

# Misc. functions to extend OS X application control
# TODO create a function to relaunch a launchctl daemon
if [[ $IS_MAC -eq 1 ]]; then
	function fix_airplay {
	  sudo kill $(ps -ax | grep 'coreaudiod' | grep 'sbin' |awk '{print $1}')
	}
	

	# Quit running application
	quit () {
	    for app in $*; do
	        osascript -e 'quit app "'$app'"'
	    done
	}
	
	# relaunch application
	relaunch () {
	    for app in $*; do
	        osascript -e 'quit app "'$app'"';
	        sleep 5;
	        open -a $app
	    done
	}
	
  # Force eject a volume
	
	function forceeject () {
    if (( $# == 0 ))
      then echo "Please specify a volume."; 
      else
        hdiutil detach -force $1;
    fi
  }
	
	# Repair the "Open with…" menu in the Finder
	function fixopenwith () {
    /System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/\
      LaunchServices.framework/Versions/A/Support/lsregister -kill -r -domain local -domain user; 
    killall Finder; 
    echo 'Open With has been rebuilt, Finder will relaunch'
  }
  
	# Repair the services available in the OS X share sheet
	function fixsharesheet () {
    /System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/\
      LaunchServices.framework/Versions/A/Support/lsregister -kill -seed; 
    killall Finder; 
    echo 'Sharing services have been reseeded, check your share sheet options.'
  }
  
  # -------------------------------------------------------------------
  # Collection of aliases from matias bynens dotfiles
  # -------------------------------------------------------------------
  
  # Hide/show all desktop icons (useful when presenting)
  function hidedesktop () {
    defaults write com.apple.finder CreateDesktop -bool false && killall Finder
  }
  function showdesktop () {
    defaults write com.apple.finder CreateDesktop -bool true && killall Finder
  }
  
  # Merge PDF files
  # Usage: `mergepdf -o output.pdf input{1,2,3}.pdf`
  function mergepdf () {
    /System/Library/Automator/Combine\ PDF\ Pages.action/Contents/Resources/join.py
  }
  
  # Disable/enable Spotlight
  function spotoff () {
    sudo mdutil -a -i off
  }
  function spoton () {
    sudo mdutil -a -i on
  }
  
  # Lock the screen (when going AFK)
  function afk () {
    /System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend
  }
  
fi


# Detect empty enter, execute git status if in git dir
magic-enter () {
        if [[ -z $BUFFER ]]; then
          if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
            echo -ne '\n'
            git status 
          fi
          zle accept-line
        else
          zle accept-line
        fi
}

zle -N magic-enter
bindkey "^M" magic-enter

function exists { which $1 &> /dev/null }

function markdownify () {
	pbpaste | multimarkdown | textutil -convert rtf -stdin -stdout -format html > ${TMPDIR}tmp-md2rtf.rtf; \
	pbcopy -Prefer rtf < ${TMPDIR}tmp-md2rtf.rtf; \
	rm ${TMPDIR}tmp-md2rtf.rtf
}

# Provide universal function for extracting archives
# Superceded by `extract` plugin for Oh-my-zsh
# function extract {
#   echo Extracting $1 ...
#   if [ -f $1 ] ; then
#       case $1 in
#           *.tar.bz2)   tar xjf $1  ;;
#           *.tar.gz)    tar xzf $1  ;;
#           *.bz2)       bunzip2 $1  ;;
#           *.rar)       unrar x $1    ;;
#           *.gz)        gunzip $1   ;;
#           *.tar)       tar xf $1   ;;
#           *.tbz2)      tar xjf $1  ;;
#           *.tgz)       tar xzf $1  ;;
#           *.zip)       unzip $1   ;;
#           *.Z)         uncompress $1  ;;
#           *.7z)        7z x $1  ;;
#           *)        echo "'$1' cannot be extracted via extract()" ;;
#       esac
#   else
#       echo "'$1' is not a valid file"
#   fi
# }
