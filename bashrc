# Bash configuration (no framework) for bash 5+ on macOS and Linux.
# Login shells reach this through bash_profile.

# ----- Environment (all shells) ---------------------------------------------

# Add a directory to the front of PATH once, and only if it exists
__path_prepend() {
	[[ -d $1 && ":$PATH:" != *":$1:"* ]] && PATH="$1:$PATH"
}

# macOS default PATH from /etc/paths and /etc/paths.d
if [[ -x /usr/libexec/path_helper ]]; then
	eval "$(/usr/libexec/path_helper -s)"
fi

# Homebrew: Apple Silicon, Intel, then Linuxbrew
for brew in /opt/homebrew/bin/brew /usr/local/bin/brew /home/linuxbrew/.linuxbrew/bin/brew "$HOME/.linuxbrew/bin/brew"; do
	if [[ -x $brew ]]; then
		eval "$("$brew" shellenv)"
		break
	fi
done
unset brew

__path_prepend "$HOME/.local/bin"
__path_prepend "$HOME/bin"
export PATH

export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
# Default to en_US.UTF-8 where it's installed; minimal Linux images often only have C.UTF-8
if [[ -z ${LANG-} ]]; then
	if locale -a 2> /dev/null | grep -qiE '^en_US\.utf-?8$'; then
		export LANG=en_US.UTF-8
	else
		export LANG=C.UTF-8
	fi
fi
if [[ -z ${EDITOR-} ]]; then
	if EDITOR=$(command -v vim || command -v vi || command -v nano); then
		export EDITOR
	else
		unset EDITOR
	fi
fi

# Stop here for non-interactive shells (scripts, scp, etc.)
[[ $- == *i* ]] || return

# ----- Interactive settings -------------------------------------------------

unset MAILCHECK
HISTCONTROL=ignoreboth:erasedups
HISTSIZE=50000
HISTFILESIZE=50000
HISTTIMEFORMAT='%F %T  '
shopt -s histappend checkwinsize cdspell dirspell globstar autocd checkjobs
# Write each command to the history file right away, so sessions don't lose it
PROMPT_COMMAND="history -a${PROMPT_COMMAND:+; $PROMPT_COMMAND}"

# GNU ls on Linux, BSD ls on macOS
if ls --color=auto -d . > /dev/null 2>&1; then
	alias ls='ls --color=auto'
else
	export CLICOLOR=1
fi
alias ll='ls -lAh'
alias grep='grep --color=auto'

# bash-completion v2: Homebrew, then the distro's copy. Skip it if
# /etc/profile or /etc/bash.bashrc already loaded it.
if [[ -z ${BASH_COMPLETION_VERSINFO-} ]]; then
	for completion in "${HOMEBREW_PREFIX:-/nonexistent}/etc/profile.d/bash_completion.sh" \
		/usr/share/bash-completion/bash_completion /etc/bash_completion; do
		if [[ -r $completion ]]; then
			source "$completion"
			break
		fi
	done
	unset completion
fi

if command -v zoxide > /dev/null; then
	eval "$(zoxide init bash --cmd cd)"
fi

# ----- Prompt ---------------------------------------------------------------
# Two lines, after bash-it's zork theme:
#   ┌─(venv)[user][host][± main ✓][~/dir]
#   └─▪
# Basic ANSI colors only, so the terminal theme decides how they look. Over
# SSH the host is yellow and the window title includes user@host.

__prompt_git() {
	local branch
	branch=$(git symbolic-ref --short HEAD 2> /dev/null || git rev-parse --short HEAD 2> /dev/null) || return
	if [[ -n $(git status --porcelain --untracked-files=no 2> /dev/null) ]]; then
		printf '[\001\e[1;32m\002±\001\e[0m\002 %s \001\e[1;31m\002✗\001\e[0m\002]' "$branch"
	else
		printf '[\001\e[1;32m\002±\001\e[0m\002 %s \001\e[1;32m\002✓\001\e[0m\002]' "$branch"
	fi
}

__prompt_env() {
	local env=${CONDA_DEFAULT_ENV:-${VIRTUAL_ENV##*/}}
	[[ -n $env ]] && printf '(\001\e[1;35m\002%s\001\e[0m\002)' "$env"
}

if (( EUID == 0 )); then
	__prompt_user='\[\e[1;31m\]\u\[\e[0m\]'
else
	__prompt_user='\[\e[1;32m\]\u\[\e[0m\]'
fi

if [[ -n ${SSH_CONNECTION-} ]]; then
	__prompt_host='\[\e[33m\]\h\[\e[0m\]'
	__prompt_title='\[\e]0;\u@\h: \w\a\]'
else
	__prompt_host='\[\e[32m\]\h\[\e[0m\]'
	__prompt_title='\[\e]0;\w\a\]'
fi

PS1="${__prompt_title}┌─\$(__prompt_env)[${__prompt_user}][${__prompt_host}]\$(__prompt_git)[\[\e[36m\]\w\[\e[0m\]]\n└─▪ "
PS2='└─▪ '
unset __prompt_user __prompt_host __prompt_title
