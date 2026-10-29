# Homebrew: Apple Silicon, Intel, then Linuxbrew. Found by directory instead of
# running `brew --prefix`, which costs a subprocess on every shell start.
# (macOS's /etc/zprofile already runs path_helper for the default PATH.)
for prefix in /opt/homebrew /usr/local /home/linuxbrew/.linuxbrew $HOME/.linuxbrew; do
  if [[ -x $prefix/bin/brew ]]; then
    export HOMEBREW_PREFIX=$prefix
    export HOMEBREW_CELLAR="$prefix/Cellar"
    export HOMEBREW_REPOSITORY=$prefix
    [[ $prefix == /opt/homebrew ]] || HOMEBREW_REPOSITORY="$prefix/Homebrew"
    export INFOPATH="$prefix/share/info${INFOPATH:+:$INFOPATH}"
    break
  fi
done
unset prefix

# Set XDG variables if not present
export XDG_DATA_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-${HOME}/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-${HOME}/.cache}"

export TEXMFHOME="$XDG_DATA_HOME/texmf"

# pixi installs global tools here; its settings stay in ~/.config/pixi
export PIXI_HOME="$XDG_DATA_HOME/pixi"

manpath=(
  ${HOMEBREW_PREFIX:+$HOMEBREW_PREFIX/share/man}(N)
  $manpath
)
typeset -U manpath

path=(
  ~/.pyenv/bin(N)
  ~/.local/bin(N)
  ~/bin(N)
  ~/.cask/bin(N)
  ~/.cargo/bin(N)
  $PIXI_HOME/bin(N)
  ${HOMEBREW_PREFIX:+$HOMEBREW_PREFIX/bin}(N)
  ${HOMEBREW_PREFIX:+$HOMEBREW_PREFIX/sbin}(N)
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

# True if a command is on PATH (zsh's command hash table; no subshell)
function _command_exists() {
  (( $+commands[$1] ))
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
# Completion cache (compinit dump), per host and zsh version
[[ -d $XDG_CACHE_HOME/zsh ]] || mkdir -p "$XDG_CACHE_HOME/zsh"
export ZSH_COMPDUMP="$XDG_CACHE_HOME/zsh/zcompdump-${HOST%%.*}-${ZSH_VERSION}"

# Leave these commands out of the history file
HISTORY_IGNORE='(ls|cd|cd -|pwd|exit|date|* --help)'

# Prefer US English with UTF-8 when nothing is set; minimal Linux images often
# only have C.UTF-8. LC_ALL is left alone so per-category settings still work.
if [[ -z $LANG ]]; then
  if [[ $IS_MAC -eq 1 ]] || locale -a 2> /dev/null | grep -qiE '^en_US\.utf-?8$'; then
    export LANG=en_US.UTF-8
  else
    export LANG=C.UTF-8
  fi
fi

