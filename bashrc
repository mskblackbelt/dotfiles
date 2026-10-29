# Bash configuration (no framework). Works with macOS's bash 3.2 and newer.
# Login shells reach this through bash_profile.

# ----- Environment (all shells) ---------------------------------------------

# macOS default PATH from /etc/paths and /etc/paths.d
if [[ -x /usr/libexec/path_helper ]]; then
	eval "$(/usr/libexec/path_helper -s)"
fi

# Homebrew (Apple Silicon, Intel, or Linuxbrew)
for brew in /opt/homebrew/bin/brew /usr/local/bin/brew "$HOME/.linuxbrew/bin/brew"; do
	if [[ -x $brew ]]; then
		eval "$("$brew" shellenv)"
		break
	fi
done
unset brew

export PATH="$HOME/bin:$HOME/.local/bin:$PATH"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export LANG="en_US.UTF-8"
export EDITOR="${EDITOR:-vi}"

# Stop here for non-interactive shells (scripts, scp, etc.)
[[ $- == *i* ]] || return

# ----- Interactive settings -------------------------------------------------

unset MAILCHECK
HISTCONTROL=ignoreboth:erasedups
HISTSIZE=10000
HISTFILESIZE=10000
shopt -s histappend checkwinsize cdspell

export CLICOLOR=1
alias ls='ls -G'
alias ll='ls -lAh'
alias grep='grep --color=auto'

# Completion from Homebrew's bash-completion (v2, then v1). Skipped on macOS's
# bash 3.2, which can't parse the completions modern tools install.
if [[ -n ${HOMEBREW_PREFIX-} ]] && (( BASH_VERSINFO[0] >= 4 )); then
	for completion in "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh" "$HOMEBREW_PREFIX/etc/bash_completion"; do
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
# Basic ANSI colors only, so the terminal theme decides how they look.

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

if [[ $EUID -eq 0 ]]; then
	__prompt_user='\[\e[1;31m\]\u\[\e[0m\]'
else
	__prompt_user='\[\e[1;32m\]\u\[\e[0m\]'
fi

PS1='\[\e]0;\w\a\]┌─$(__prompt_env)['"$__prompt_user"'][\[\e[32m\]\h\[\e[0m\]]$(__prompt_git)[\[\e[36m\]\w\[\e[0m\]]\n└─▪ '
PS2='└─▪ '
