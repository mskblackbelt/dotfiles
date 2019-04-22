# path_helper creates a default path based on the contents of /etc/paths.d and /etc/manpaths.d
# The function should be run as part of /etc/zshenv
if [[ $IS_MAC -eq 1 ]]; then
	unset PATH
	eval `/usr/libexec/path_helper -s`
fi
export PATH="$PATH:$HOME/bin:$HOME/bin/anaconda/bin:$HOME/.local/bin"


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
export LESS='--ignore-case --raw-control-chars'
if [[ -x `which most 2> /dev/null` ]]; then 
	export PAGER='most'
	export MANPAGER='/usr/bin/less -X'
fi
if [[ -x `which bat 2> /dev/null` ]]; then 
	export BAT_PAGER='/usr/bin/less' 
	export BAT_THEME="TwoDark"
fi

if [[ $IS_MAC -eq 1 ]]; then
  export EDITOR='mate -w'
  export TEXEDIT='mate -w -l %d "%s"'
elif [[ -x `which code 2> /dev/null` ]]; then
  export EDITOR='code -w'
elif [[ -x `which kate 2> /dev/null` ]]; then
  export EDITOR='kate -n -l %d'
else
  export EDITOR='vi'
fi

export GNUTERM='svg' # Terminal used for gnuplot, matplotlib


# Set up history file location and size 
# The following two lines are set by Oh-my-ZSH
# export HISTSIZE=5000 
# export SAVEHIST=5000 
export HISTFILE="$ZDOTDIR/.zsh_history"
export ZSH_COMPDUMP="${HOME}/.zcompdump-${SHORT_HOST}-${ZSH_VERSION}"

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

