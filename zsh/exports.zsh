if [[ $IS_MAC -eq 1 ]]; then
  # path_helper creates a default path based on the contents of /etc/paths.d and /etc/manpaths.d
  # The function is run as part of /etc/zshenv by default.
	# unset PATH
  # eval `/usr/libexec/path_helper -s`

  # Add homebrew binaries to the path
	if [[ -x /opt/homebrew/bin/brew ]]; then
    export HOMEBREW_PREFIX=$(/opt/homebrew/bin/brew --prefix);
    export HOMEBREW_CELLAR="$HOMEBREW_PREFIX/Cellar";
    # export PATH="$HOMEBREW_PREFIX/bin:$HOMEBREW_PREFIX/sbin${PATH+:$PATH}";
    export MANPATH="$HOMEBREW_PREFIX/share/man${MANPATH+:$MANPATH}:";
    export INFOPATH="$HOMEBREW_PREFIX/share/info:${INFOPATH:-}";
  fi

# Add linuxbrew directory if present
elif [[ -d $HOME/.linuxbrew ]]; then
   eval $($HOME/.linuxbrew/bin/brew shellenv);
   export HOMEBREW_PREFIX=$(brew --prefix);
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
  ~/.cargo/bin(N)
  ~/bin/anaconda/bin(N)
  /opt/homebrew/bin(N)
  /usr/local/bin(N)
  /usr/bin
  /bin
  /opt/homebrew/sbin(N)
  /usr/local/sbin(N)
  /usr/sbin
  /sbin
  /Library/TeX/texbin(N)
  $path
)
typeset -U path # U for Unique, like a set; (N) == only if exists

# Helper function for checking if a binary exists and is executable
function _command_executable() {
  local _binary="$1" _full_path

  # Checks if the binary is available.
  _full_path=$( whence "$_binary" )
  commandStatus=$?
  if [ $commandStatus -ne 0 ]; then
    # It is not the case, if NOT in 'BSC_MODE_CHECK_CONFIG' mode, it is a fatal error.
    echo "Unable to find binary '$_binary'."
    return 201
  # Checks if the binary has "execute" permission.
  elif [ -x "$_full_path" ]; then
    return 0
  else
    echo "Binary '$_binary' found but it does not have *execute* permission."
    return 202
  fi
}

function _command_exists() {
  _command_executable "$1" > /dev/null 2>&1
}

# Export pagers and editors
export LESS='--ignore-case --raw-control-chars'
# if _command_exists "most"; then
# 	export PAGER='most'
# 	export MANPAGER='/usr/bin/less -X'
# fi
if _command_exists bat; then
  # export BAT_PAGER='/usr/bin/less'
  export BAT_THEME="ansi"
fi

if _command_exists nova; then
  export EDITOR='nova -w'
  export TEXEDIT='nova -w -l %d "%s"'
  export GIT_EDITOR="nova  -w -l 1"
elif _command_exists mate; then
  export EDITOR='mate -w'
  export TEXEDIT='mate -w -l %d "%s"'
  export GIT_EDITOR="mate --name 'Git Commit Message' -w -l 1"
elif _command_exists code; then
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

