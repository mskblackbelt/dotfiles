#!/usr/bin/env bash
#
# Set up these dotfiles on macOS or Linux. Safe to re-run.
#
#   git clone https://github.com/mskblackbelt/dotfiles.git ~/Developer/dotfiles
#   ~/Developer/dotfiles/init/setup.sh
#
# Options:
#   -y   answer yes to every question (unattended)
#
# Without a terminal (e.g. `setup.sh < /dev/null`) the optional steps are
# skipped. Nothing is deleted: files in the way of a link are moved to
# ~/.local/state/dotfiles-backup/<date>/.
#
# Written for bash 3.2, which is all a fresh Mac has.
set -uo pipefail

repo="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
private_dir="$(dirname "$repo")/dotfiles-private"
backup_dir="${XDG_STATE_HOME:-$HOME/.local/state}/dotfiles-backup/$(date +%Y%m%d-%H%M%S)"
rcm_version=1.3.6
os=$(uname -s)
assume_yes=false
[[ ${1-} == -y ]] && assume_yes=true

say() { printf '\n\033[1m==> %s\033[0m\n' "$*"; }
note() { printf '    %s\n' "$*"; }
have() { command -v "$1" > /dev/null 2>&1; }
# Show a path with ~ for $HOME (a variable, because bash 3.2 and 5 treat a literal ~ differently here)
tilde() { local t='~'; printf '%s' "${1/#$HOME/$t}"; }
# ask "question": yes with -y, no without a terminal, otherwise ask
ask() {
	$assume_yes && return 0
	[[ -t 0 ]] || return 1
	local reply
	read -r -p "    $1 [y/N] " reply
	[[ $reply == [yY]* ]]
}
# Move something out of the way, keeping its path relative to $HOME
backup() {
	local rel=${1#"$HOME"/}
	mkdir -p "$backup_dir/$(dirname "$rel")"
	mv "$1" "$backup_dir/$rel"
	note "moved ~/$rel to $(tilde "$backup_dir")/$rel"
}

# rcrc expects the repo at ~/Developer/dotfiles
if [[ $repo != "$HOME/Developer/dotfiles" ]]; then
	echo "This repo is at $repo, but rcrc expects ~/Developer/dotfiles." >&2
	echo "Move or re-clone it there, then run this again." >&2
	exit 1
fi

# ----- Prerequisites ---------------------------------------------------------

install_rcm_locally() {
	say "Building rcm $rcm_version into ~/.local (no root needed)"
	local tmp url="https://thoughtbot.github.io/rcm/dist/rcm-$rcm_version.tar.gz"
	tmp=$(mktemp -d)
	if have curl; then curl -fsSL "$url" -o "$tmp/rcm.tar.gz"; else wget -qO "$tmp/rcm.tar.gz" "$url"; fi &&
		tar -xzf "$tmp/rcm.tar.gz" -C "$tmp" &&
		(cd "$tmp/rcm-$rcm_version" && ./configure --prefix="$HOME/.local" > /dev/null && make install > /dev/null) ||
		{ echo "Couldn't build rcm; install it with your package manager and re-run." >&2; exit 1; }
	export PATH="$HOME/.local/bin:$PATH"
}

if [[ $os == Darwin ]]; then
	say "Checking macOS prerequisites"
	if ! xcode-select -p > /dev/null 2>&1; then
		xcode-select --install
		echo "Finish installing the Command Line Tools, then run this again." >&2
		exit 1
	fi
	for prefix in /opt/homebrew /usr/local; do
		[[ -x $prefix/bin/brew ]] && eval "$("$prefix/bin/brew" shellenv)" && break
	done
	if ! have brew && ask "Homebrew isn't installed. Install it?"; then
		NONINTERACTIVE=$($assume_yes && echo 1) /bin/bash -c \
			"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
		for prefix in /opt/homebrew /usr/local; do
			[[ -x $prefix/bin/brew ]] && eval "$("$prefix/bin/brew" shellenv)" && break
		done
	fi
	if ! have rcup; then
		if have brew; then brew install rcm; else install_rcm_locally; fi
	fi
else
	say "Checking Linux prerequisites"
	if ! have rcup; then
		pm=""
		for candidate in apt-get dnf yum zypper pacman; do have $candidate && pm=$candidate && break; done
		if [[ -n $pm ]] && have sudo && ask "Install rcm with sudo $pm?"; then
			case $pm in
				pacman) sudo pacman -S --noconfirm rcm ;;
				*) sudo "$pm" install -y rcm ;;
			esac
		fi
		have rcup || install_rcm_locally
	fi
fi
note "rcm: $(command -v rcup)"

# ----- Private companion repo ----------------------------------------------

say "Private dotfiles"
if [[ -d $private_dir/.git ]]; then
	note "found $private_dir"
elif GIT_SSH_COMMAND="ssh -o BatchMode=yes" git clone -q git@github.com:mskblackbelt/dotfiles-private.git "$private_dir" 2> /dev/null ||
	GIT_TERMINAL_PROMPT=0 git clone -q https://github.com/mskblackbelt/dotfiles-private.git "$private_dir" 2> /dev/null; then
	note "cloned into $private_dir"
else
	note "skipped: no access from this machine (git identity and ssh hosts won't be set up)."
	note "To add it later: gh auth login && gh auth setup-git, then re-run."
fi

# ----- Frameworks -------------------------------------------------------------

say "Frameworks"
externals=()
have zsh && externals+=(oh-my-zsh)
have emacs && externals+=(spacemacs)
if (( ${#externals[@]} )); then
	# Older setups linked these into the repo; update-externals won't replace a link
	for link in "$HOME/.emacs.d" "$HOME/.bash_it"; do
		[[ -L $link ]] && backup "$link"
	done
	"$repo/bin/update-externals" "${externals[@]}"
else
	note "skipped: neither zsh nor emacs is installed"
fi

# ----- Links -------------------------------------------------------------------

say "Linking dotfiles"
export RCRC="$repo/rcrc"
# Move anything already at a link's location aside, so rcup never has to ask
while IFS=: read -r target source; do
	if [[ -L $target && $(readlink "$target") == "$source" ]]; then
		continue
	elif [[ -e $target || -L $target ]]; then
		backup "$target"
	fi
done < <(lsrc)
# git reads ~/.gitconfig after ~/.config/git/config; keep it as a machine-local
# file for apps that write global settings, and move an old full config aside
if [[ -f $HOME/.gitconfig && ! -L $HOME/.gitconfig ]] && ! grep -q '^# Machine-local git settings' "$HOME/.gitconfig"; then
	backup "$HOME/.gitconfig"
fi
if [[ ! -e $HOME/.gitconfig ]]; then
	cat > "$HOME/.gitconfig" << 'EOF'
# Machine-local git settings (not in the dotfiles repo).
# Shared settings live in ~/.config/git/config; git reads this file after it,
# and apps that run `git config --global` (SourceTree, gh, ...)
# write here, which keeps their changes out of the repo.
EOF
fi
rcup -v | grep -v '^identical ' | sed "s|$HOME|~|g; s/^/    /"

# ----- Optional steps ------------------------------------------------------------

if [[ $os == Darwin ]]; then
	if have brew; then
		say "Homebrew packages"
		if ask "Install everything in init/Brewfile? (takes a while)"; then
			brew bundle --file "$repo/init/Brewfile"
		else
			note "skipped; run later: brew bundle --file $repo/init/Brewfile"
		fi
	fi

	brew_zsh="${HOMEBREW_PREFIX:-/opt/homebrew}/bin/zsh"
	if [[ -x $brew_zsh && $(dscl . -read "/Users/$USER" UserShell 2> /dev/null | awk '{print $2}') != "$brew_zsh" ]]; then
		say "Login shell"
		if ask "Make Homebrew's zsh ($brew_zsh) your login shell?"; then
			grep -qx "$brew_zsh" /etc/shells || echo "$brew_zsh" | sudo tee -a /etc/shells > /dev/null
			chsh -s "$brew_zsh"
		fi
	fi

	say "macOS settings"
	if ask "Apply the macOS settings in init/macos-defaults.sh? (needs your password)"; then
		"$repo/init/macos-defaults.sh"
	else
		note "skipped; run later: $repo/init/macos-defaults.sh"
	fi
fi

say "Done"
[[ -d $backup_dir ]] && note "Replaced files are in $(tilde "$backup_dir")"
note "Open a new terminal to pick up the shell configuration."
