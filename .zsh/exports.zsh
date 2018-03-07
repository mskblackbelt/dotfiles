# path_helper creates a default path based on the contents of /etc/paths.d and /etc/manpaths.d
# The function should be run as part of /etc/zshenv
if [[ $IS_MAC -eq 1 ]]; then
	unset PATH
	eval `/usr/libexec/path_helper -s`
fi
export PATH="$PATH:$HOME/bin:$HOME/bin/anaconda/bin"

if [[ -d /usr/local/opt/ccache/libexec ]]; then
	export PATH="/usr/local/opt/ccache/libexec:$PATH"
fi

# Setup terminal, and turn on colors
export TERM=xterm-256color
# Comment out the following two lines if using colors.zsh
# export CLICOLOR=1
# export LSCOLORS=Gxfxcxdxbxegedabagacad

# Enable color in grep
export GREP_OPTIONS='--color=auto'
export GREP_COLOR='3;33'

# This resolves issues install the mysql, postgres, and other gems with native non universal binary extensions
if [[ $IS_MAC -eq 1 ]]; then
	export ARCHFLAGS='-arch x86_64'
fi

# Export pagers and editors
export GNUTERM='X11' # Terminal used for gnuplot, matplotlib
export LESS='--ignore-case --raw-control-chars'
if [[ -x `which most 2> /dev/null` ]]; then 
	export PAGER='most' 
fi

if [[ $IS_MAC -eq 1 && -x `which geany 2> /dev/null` ]]; then
  export EDITOR='mate -w'
  export TEXEDIT='mate -w -l %d "%s"'
elif [[ -x `which geany 2> /dev/null` ]]; then
  export EDITOR='geany -s'
elif [[ -x `which kate 2> /dev/null` ]]; then
  export EDITOR='kate -n -l %d'
else
  export EDITOR='vi'
fi


# Set up history file location and size 
# The following two lines are set by Oh-my-ZSH
# export HISTSIZE=5000 
# export SAVEHIST=5000 
export HISTFILE="$ZDOTDIR/.zsh_history"
export ZSH_COMPDUMP="${HOME}/.zcompdump-${SHORT_HOST}-${ZSH_VERSION}"


