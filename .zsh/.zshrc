# Set so that all other sourced files can be found.
export ZDOTDIR="$HOME/Projects/dotfiles/.zsh"

## If slowdown issues occur, add this line to $ZSH/oh-my-zsh.sh where plugins are sourced (line 85?)
# echo $plugin && { time (source $ZSH/plugins/$plugin/$plugin.plugin.zsh) }

source $ZDOTDIR/checks.zsh
source $ZDOTDIR/colors.zsh
source $ZDOTDIR/exports.zsh
source $ZDOTDIR/oh-my-zsh_opts.zsh
source $ZDOTDIR/setopt.zsh
source $ZDOTDIR/pyopts.zsh
source $ZDOTDIR/perlopts.zsh
source $ZDOTDIR/completion.zsh
source $ZDOTDIR/aliases.zsh
source $ZDOTDIR/bindkeys.zsh
source $ZDOTDIR/functions.zsh
source $ZDOTDIR/zsh_hooks.zsh
source $ZDOTDIR/private.zsh
source $ZDOTDIR/local.zsh
source $ZDOTDIR/prompt.zsh


# Enable ZSH syntax highlighting
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh


#Autoload modules
module_path=($module_path)
if [[ -e /usr/local/lib/zpython ]]; then
  module_path=($module_path /usr/local/lib/zpython)
  zmodload zsh/zpython
fi
autoload -U zcalc
[[ -e $(alias run-help) ]] && unalias run-help
autoload run-help
HELPDIR=/usr/local/share/zsh/helpfiles

# Clean duplicates from $PATH
if [ -n "$PATH" ]; then
  old_PATH=$PATH:; PATH=
  while [ -n "$old_PATH" ]; do
    x=${old_PATH%%:*}       # the first remaining entry
    case $PATH: in
      *:"$x":*) ;;         # already there
      *) PATH=$PATH:$x;;    # not there yet
    esac
    old_PATH=${old_PATH#*:}
  done
  PATH=${PATH#:}
  unset old_PATH x
fi

