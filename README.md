# mskblackbelt’s dotfiles

Shell, git, editor, and app configuration for macOS and Linux, linked into place with [`rcm`](https://thoughtbot.github.io/rcm/rcm.7.html).

## Installation

### Using Git and the setup script

Clone the repository to `~/Developer/dotfiles` (`rcrc` expects it there), then run the setup script:

```bash
git clone https://github.com/mskblackbelt/dotfiles.git ~/Developer/dotfiles
~/Developer/dotfiles/init/setup.sh
```

The script is safe to re-run. It:

1. Installs what it needs. On macOS that's the Command Line Tools, [Homebrew](https://brew.sh), and `rcm`. On Linux it installs `rcm` with the system package manager, or builds it into `~/.local` if you don't have root.
2. Clones the private companion repo, `dotfiles-private`, next to this one if this machine has access to it.
3. Clones or updates oh-my-zsh and Spacemacs (`bin/update-externals`).
4. Links the dotfiles with `rcup`. Files already in the way are moved to `~/.local/state/dotfiles-backup/<date>/`, never deleted.
5. On macOS, offers to install the Brewfile, make Homebrew’s zsh your login shell, and apply the macOS settings.

Pass `-y` to answer yes to every question. Without a terminal (`setup.sh < /dev/null`), the optional steps are skipped.

To link the files by hand instead:

```bash
env RCRC=~/Developer/dotfiles/rcrc rcup
```

<!-- TODO: Remove this section once every machine has been migrated (added November 2026). -->
### Migrating a machine with an old clone

This repo’s history was rewritten in October 2026, so don’t pull into an older clone; that would bring the removed history back. Replace the clone instead:

1. Remove the links rcm made from the old clone (skip this if `rcm` isn’t installed or the clone lives elsewhere; `setup.sh` backs up anything left in the way):
   ```bash
   env RCRC=~/Developer/dotfiles/rcrc rcdn
   ```
2. Move the old clone aside:
   ```bash
   mv ~/Developer/dotfiles ~/Developer/dotfiles.old
   ```
3. Clone fresh and run the setup script:
   ```bash
   git clone https://github.com/mskblackbelt/dotfiles.git ~/Developer/dotfiles
   ~/Developer/dotfiles/init/setup.sh
   ```
4. Check for links still pointing into the old clone (this should print nothing):
   ```bash
   find ~ -maxdepth 3 -type l -lname '*dotfiles.old*' 2>/dev/null
   ```
5. Once everything works, delete the old clone:
   ```bash
   rm -rf ~/Developer/dotfiles.old
   ```

`setup.sh` also moves aside the old `~/.emacs.d` and `~/.bash_it` submodule links and clones Spacemacs and oh-my-zsh fresh. `dotfiles-private` wasn’t rewritten; a plain `git pull` there is fine.

### Sensible macOS defaults

When setting up a new Mac, you may want to set some sensible macOS defaults:

```bash
./init/macos-defaults.sh
```

### Install Homebrew formulae

To install the [Homebrew](https://brew.sh) formulae, casks, and Mac App Store apps:

```bash
brew bundle --file ./init/Brewfile
```

Everything above the **Home** and **Work** sections installs on every Mac. Those two sections are commented out; uncomment what a given machine needs.

## Layout

| Path | Contents |
|---|---|
| `zshrc`, `zsh/` | Zsh configuration, split by topic; oh-my-zsh lives in `~/.local/share/oh-my-zsh` |
| `config/` | Files for `~/.config` (git, Ghostty, pixi, latexmk, md-fixup, and more) |
| `tag-darwin/`, `tag-linux/` | Per-OS files; `rcm` links only the current OS’s set |
| `bin/` | Scripts, linked to `~/bin` |
| `local/share/` | Pandoc templates, TeX files, and images for `~/.local/share` |
| `init/` | Setup script, macOS defaults, and the Brewfile (not linked) |

### Machine-local and private settings

Some settings stay out of this repo:

* **`dotfiles-private`** holds the git identity (`gitconfig.local`) and SSH hosts. `rcm` links it alongside this repo.
* **`~/.gitconfig`** is a plain local file. Git reads it after `~/.config/git/config`, and apps that run `git config --global` write there.
* **`zsh/local.zsh`** is ignored by git, for machine-specific exports.

## Feedback

Suggestions/improvements
[welcome](https://github.com/mskblackbelt/dotfiles/issues)!

## Thanks to…

* @mathiasbynens and his [dotfiles repository](https://github.com/mathiasbynens/dotfiles)
