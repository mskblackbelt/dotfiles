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
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in $ZDOTDIR/{\
colors,\
exports,\
checks,\
oh-my-zsh_opts,\
setopt,\
pyopts,\
perlopts,\
completion,\
aliases,\
bindkeys,\
functions,\
zsh_hooks,\
private,\
local,\
prompt,\
iterm2_shell_integration\
}.zsh; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;


#Autoload modules
module_path=($module_path)
autoload -U zcalc
[[ -e $(alias run-help) ]] && unalias run-help
autoload run-help
HELPDIR=/usr/local/share/zsh/helpfiles

# Clean duplicates from $PATH
typeset -U path # -U for unique
path=($path)
# export $PATH

# Enable ZSH syntax highlighting (must be loaded at the end of .zshrc)
if [[ -e /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif
  [[ -e /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
    source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
