# macOS-only git settings, linked to ~/.gitconfig.os by rcm (tag "darwin").
# Included from ~/.config/git/config.

[credential]
	helper = osxkeychain

# Sign commits with the SSH key held in 1Password (key: user.signingkey in ~/.gitconfig.local)
[gpg]
	format = ssh
[gpg "ssh"]
	program = /Applications/1Password.app/Contents/MacOS/op-ssh-sign
[commit]
	gpgsign = true

[core]
	pager = delta
[interactive]
	diffFilter = delta --color-only --features=interactive

# GUI tools: `git mergetool` and `git difftool -g` open VS Code
# (`git difftool` stays on difftastic in the terminal)
[merge]
	tool = vscode
[diff]
	guitool = vscode

# Jupyter notebook diffs and merges via nbdime (see ~/.config/git/attributes)
[diff "jupyternotebook"]
	command = git-nbdiffdriver diff
[merge "jupyternotebook"]
	driver = git-nbmergedriver merge %O %A %B %L %P
	name = jupyter notebook merge driver
[difftool "nbdime"]
	cmd = git-nbdifftool diff \"$LOCAL\" \"$REMOTE\" \"$BASE\"
[mergetool "nbdime"]
	cmd = git-nbmergetool merge \"$BASE\" \"$LOCAL\" \"$REMOTE\" \"$MERGED\"
