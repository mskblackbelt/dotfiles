# path_helper creates a default path based on the contents of /etc/paths.d and /etc/manpaths.d
# The function is run as part of /etc/zshenv by default. 
if [[ $IS_MAC -eq 1 ]]; then
	unset PATH
	eval `/usr/libexec/path_helper -s`
fi
# export PATH="$PATH:$HOME/bin:$HOME/bin/anaconda/bin:$HOME/.local/bin"

typeset -U path # U for Unique, like a set; (N) == only if exists
path=(
  ~/.pyenv/bin(N)
  ~/.local/bin(N) 
  ~/bin(N) 
  ~/.cask/bin(N) 
  ~/bin/anaconda/bin(N)
  $path
)

if [[ -d $HOME/.linuxbrew ]]; then
   eval $($HOME/.linuxbrew/bin/brew shellenv)
fi

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
  export GIT_EDITOR="mate --name 'Git Commit Message' -w -l 1"
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

