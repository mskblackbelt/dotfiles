function zsh_recompile {
  autoload -U zrecompile
  rm -f $ZDOTDIR/**/*.zwc(N)
  [[ -f $HOME/.zshrc ]] && zrecompile -p $HOME/.zshrc
  rm -f $HOME/.zshrc.zwc.old(N)

  for f in $ZSH/**/*.zsh(N); do
    zrecompile -p $f
    rm -f $f.zwc.old(N)
  done

  [[ -f $ZSH_COMPDUMP ]] && zrecompile -p $ZSH_COMPDUMP
  rm -f $ZSH_COMPDUMP.zwc.old(N)

  source $HOME/.zshrc
}

# Wrapper for zsh function information
zinfo() {info --index-search="$*" zsh}

# calculator plugin, aliases assigned in `aliases.zsh`
function __calc_plugin {
    zcalc -e "$*"
}

# Network related functions
if _command_exists ifconfig; then
  function ips () {
    ifconfig -a | perl -nle'/(\d+\.\d+\.\d+\.\d+)/ && print $1' # Machine IPs
    }
elif _command_exists ip; then
  function ips () {
    ip address show | perl -nle'/(\d+\.\d+\.\d+\.\d+)/ && print $1' # Machine IPs
    }
fi

function myip () {
  curl ipinfo.io/ip # External IP
  }

function flush () {
  sudo killall -HUP mDNSResponder # Flush DNS cache
  }
  
if _command_exists uvx; then
  function speedtest () {
    uvx speedtest-cli; 
    }
fi

# Misc. functions to extend OS X application control
# TODO create a function to relaunch a launchctl daemon
if [[ $IS_MAC -eq 1 ]]; then

  # Convert Markdown on the clipboard to rich text
  function md2rtf () {
    pbpaste | apex |
      textutil -convert rtf -format html -inputencoding UTF-8 -stdin -stdout |
      pbcopy
  }

  # Convert rich text on the clipboard to Markdown
  # (browsers copy HTML; Pages, Word, and Mail copy RTF)
  function markdownify () {
    local rich type body
    rich=$(osascript -l JavaScript -e '
      ObjC.import("AppKit");
      const pb = $.NSPasteboard.generalPasteboard;
      const html = pb.stringForType("public.html").js;
      const rtf = pb.stringForType("public.rtf").js;
      html ? "html\n" + html : rtf ? "rtf\n" + rtf : ""')
    type=${rich%%$'\n'*} body=${rich#*$'\n'}
    if [[ $type == rtf ]]; then
      body=$(textutil -convert html -format rtf -stdin -stdout <<< $body)
    elif [[ $type != html ]]; then
      print -u2 "rtf2md: no rich text on the clipboard"
      return 1
    fi
    # Drop styling attributes so links and spans come out as Markdown, not HTML
    sed -E 's/ (style|class|id)="[^"]*"//g' <<< $body |
      pandoc -f html-native_spans-native_divs -t gfm --wrap=none |
      sed '/^\\$/d' | pbcopy
  }

	function fix_airplay {
	  sudo killall coreaudiod
	}
	

	# Quit running application
	quit () {
	    for app in $*; do
	        osascript -e 'quit app "'$app'"'
	    done
	}
	
	# Relaunch application
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
    /System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister -kill -seed;
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
  
  # Merge PDF files with macOS's built-in Combine PDF Pages tool, which copies
  # pages without re-rendering them
  # Usage: `mergepdf output.pdf input{1,2,3}.pdf`
  function mergepdf () {
    if (( $# < 3 )); then
      echo "Usage: mergepdf output.pdf input1.pdf input2.pdf [...]" >&2
      return 1
    fi
    local out=$1; shift
    "/System/Library/Automator/Combine PDF Pages.action/Contents/MacOS/join" -o "$out" "$@"
  }
  
  # Disable/enable Spotlight
  function spotoff () {
    sudo mdutil -a -i off
  }
  function spoton () {
    sudo mdutil -a -i on
  }
  
  # Lock the screen (when going AFK): sleeps the display, which locks it when
  # "Require password after screen saver begins or display is turned off" is on
  function afk () {
    pmset displaysleepnow
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
