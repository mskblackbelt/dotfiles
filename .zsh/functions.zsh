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
	pbpaste | /usr/local/bin/multimarkdown | textutil -convert rtf -stdin -stdout -format html > ${TMPDIR}tmp-md2rtf.rtf; \
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
