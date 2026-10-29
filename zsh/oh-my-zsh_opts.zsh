# Path to your oh-my-zsh configuration.
# Cloned and updated by bin/update-externals
ZSH="${XDG_DATA_HOME:-$HOME/.local/share}/oh-my-zsh"
ZSH_CUSTOM=$ZDOTDIR/omz_custom

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
# ZSH_THEME="af-magic"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(
  battery 
  colored-man-pages 
  git
  safe-paste
  virtualenv
)


if [[ $IS_MAC -eq 1 ]]; then
  plugins=($plugins macos textmate)
fi

if [[ $IS_LINUX -eq 1 ]]; then
  plugins=($plugins extract)
  
  if [[ $HAS_APT -eq 1 ]]; then
    plugins=($plugins debian ubuntu)
  fi

  if [[ $HAS_YUM -eq 1 ]]; then
    plugins=($plugins dnf yum)
  fi	
fi



if _command_exists brew; then
  plugins=($plugins brew)
fi

if _command_exists uv; then
  plugins=($plugins uv)
fi

# Keep oh-my-zsh's caches out of its checkout
ZSH_CACHE_DIR="$XDG_CACHE_HOME/oh-my-zsh"

# bin/update-externals updates oh-my-zsh, so turn off its own updater
zstyle ':omz:update' mode disabled

# Display red dots while waiting for completion
COMPLETION_WAITING_DOTS="true"

# Extra completion functions; must be on fpath before oh-my-zsh runs compinit
fpath=(
  ${HOMEBREW_PREFIX:+$HOMEBREW_PREFIX/share/zsh/site-functions}(N)
  ${HOMEBREW_PREFIX:+$HOMEBREW_PREFIX/share/zsh-completions}(N)
  ~/.local/zsh-completions(N)
  $fpath
)
typeset -U fpath

if [[ -r $ZSH/oh-my-zsh.sh ]]; then
  source $ZSH/oh-my-zsh.sh
else
  echo "oh-my-zsh not found at $ZSH; run update-externals" >&2
fi
