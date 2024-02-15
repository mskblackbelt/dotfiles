# mskblackbelt’s dotfiles

## Installation

### Using Git and the bootstrap script

You can clone the repository wherever you want. (I like to keep it in `~/Developer/dotfiles`) Use [`rcm`](http://thoughtbot.github.io/rcm/rcm.7.html) to link the files to your home directory.

```bash
env RCRC="~/Developer/dotfiles/rcrc" rcup
```

To install everything automatically (including [Homebrew](https://brew.sh, `rcm`, `zsh`, and `git`), `cd` into your local `dotfiles` repository and then:

```bash
./init/install.sh
```

### Sensible OS X defaults

When setting up a new Mac, you may want to set some sensible OS X defaults:

```bash
./init/macos_install.sh
```

### Install Homebrew formulae

When setting up a new Mac, you may want to install some common [Homebrew](http://brew.sh/) formulae (after installing Homebrew, of course):

```bash
brew bundle --file ./init/Brewfile
```


## Feedback

Suggestions/improvements
[welcome](https://github.com/mskblackbelt/dotfiles/issues)!

## Author

| [![twitter/mskblackbelt](https://secure.gravatar.com/avatar/c19070eaf142d30988084346ab6e693b)](http://twitter.com/mskblackbelt "Follow @mskblackbelt on Twitter") |
|---|

## Thanks to…

* @mathiasbynens and his [dotfiles repository](https://github.com/mathiasbynens/dotfiles)
