if [[ $IS_MAC -eq 1 ]]; then
  # path_helper creates a default path based on the contents of /etc/paths.d and /etc/manpaths.d
  # The function is run as part of /etc/zshenv by default. 
	unset PATH
	eval `/usr/libexec/path_helper -s`

  # Add homebrew binaries to the path
	export HOMEBREW_PREFIX="/opt/homebrew";
	export HOMEBREW_CELLAR="/opt/homebrew/Cellar";
	export HOMEBREW_REPOSITORY="/opt/homebrew";
	export PATH="/opt/homebrew/bin:/opt/homebrew/sbin${PATH+:$PATH}";
	export MANPATH="/opt/homebrew/share/man${MANPATH+:$MANPATH}:";
	export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}";
  # Add linuxbrew directory if present
elif [[ -d $HOME/.linuxbrew ]]; then
   eval $($HOME/.linuxbrew/bin/brew shellenv)
fi

# Set XDG variables if not present
export XDG_DATA_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-${HOME}/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-${HOME}/.cache}"

export TEXMFHOME="$XDG_DATA_HOME/texmf"

typeset -U path # U for Unique, like a set; (N) == only if exists
path=(
  ~/.pyenv/bin(N)
  ~/.local/bin(N) 
  ~/bin(N) 
  ~/.cask/bin(N) 
  ~/bin/anaconda/bin(N)
  $path
)

# Helper function for checking if a binary exists
function exists { which $1 &> /dev/null }

# Add rust binaries to the path
if [[ -f $HOME/.cargo/env ]]; then
  source "$HOME/.cargo/env"
fi

# Export pagers and editors
export LESS='--ignore-case --raw-control-chars'
if hash most 2>/dev/null; then 
	export PAGER='most'
	export MANPAGER='/usr/bin/less -X'
fi
if hash bat 2>/dev/null; then 
	export BAT_PAGER='/usr/bin/less' 
	export BAT_THEME="TwoDark"
fi

if hash nova 2> /dev/null; then
  export EDITOR='nova -w'
  export TEXEDIT='nova -w -l %d "%s"'
  export GIT_EDITOR="nova --name 'Git Commit Message' -w -l 1"
elif hash mate 2> /dev/null; then
  export EDITOR='mate -w'
  export TEXEDIT='mate -w -l %d "%s"'
  export GIT_EDITOR="mate --name 'Git Commit Message' -w -l 1"
elif hash code 2> /dev/null; then
  export EDITOR='code -w'
else
  export EDITOR='vi'
fi

export GNUTERM='svg' # Terminal used for gnuplot, matplotlib

# Set up history file location and size 
# The following two lines are set by Oh-my-ZSH
# export HISTSIZE=5000 
# export SAVEHIST=5000 
export HISTFILE="$HOME/.local/.zsh_history"
export ZSH_COMPDUMP="${HOME}/.local/.zcompdump-${SHORT_HOST}-${ZSH_VERSION}"

# -------------------------------------------------------------------
# Collection of exports from matias bynens dotfiles
# -------------------------------------------------------------------

# Exclude some commands from history
export HISTIGNORE="ls:cd:cd -:pwd:exit:date:* --help";

# Prefer US English and use UTF-8
export LANG="en_US.UTF-8";
export LC_ALL="en_US.UTF-8";

# Highlight section titles in manual pages
export LESS_TERMCAP_md="${yellow}";

