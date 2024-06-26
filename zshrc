# Set so that all other sourced files can be found.
export ZDOTDIR="$HOME/.zsh"

## If slowdown issues occur, add this line to $ZSH/oh-my-zsh.sh where plugins are sourced (line 85?)
# echo $plugin && { time (source $ZSH/plugins/$plugin/$plugin.plugin.zsh) }

## Initial checks for OS_TYPE so that PATH variable can be set properly. 
export OS_TYPE=$(uname -s)

if 
  [[ $OS_TYPE = 'Linux' ]]; then
  IS_LINUX=1
elif 
  [[ $OS_TYPE = 'Darwin' ]]; then
  IS_MAC=1
fi

# Load the shell dotfiles, and then some:
load_files=(
  colors
  exports
  checks
  oh-my-zsh_opts
  setopt
  pyopts
  perlopts
  completion
  aliases
  bindkeys
  functions
  zsh_hooks
  private
  local
  prompt
  iterm2_shell_integration
)
for file in $load_files; do
  file="$ZDOTDIR/$file.zsh"
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
  unset file;
done;

#Autoload modules
module_path=($module_path)
autoload -U zcalc
[[ -e $(alias run-help) ]] && unalias run-help
autoload run-help
HELPDIR=/usr/local/share/zsh/helpfiles

# Clean duplicates from $PATH
typeset -U path # -U for unique
path=($path)

# Enable ZSH syntax highlighting (must be loaded at the end of .zshrc)
if [[ -e $HOMEBREW_PREFIX/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh ]]; then
  source $HOMEBREW_PREFIX/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
  ## Need this line because of bug in whatis command called by highlighter
  function whatis() { if [[ -v THEFD ]]; then :; else command whatis "$@"; fi; }
elif [[ -e $HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source $HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
