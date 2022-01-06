# mskblackbelt’s dotfiles

## Installation

### Using Git and the bootstrap script

You can clone the repository wherever you want. (I like to keep it in `~/Projects/dotfiles`) Use [`rcm`](http://thoughtbot.github.io/rcm/rcm.7.html) to link the files to your home directory.

```bash
env RCRC="~/Projects/dotfiles/rcrc" rcup
```

To update, `cd` into your local `dotfiles` repository and then:

```bash
source bootstrap.sh
```

Alternatively, to update while avoiding the confirmation prompt:

```bash
set -- -f; source bootstrap.sh
```

### Sensible OS X defaults

When setting up a new Mac, you may want to set some sensible OS X defaults:

```bash
./.osx
```

### Install Homebrew formulae

When setting up a new Mac, you may want to install some common [Homebrew](http://brew.sh/) formulae (after installing Homebrew, of course):

```bash
brew bundle ~/Brewfile
```


## Feedback

Suggestions/improvements
[welcome](https://github.com/mskblackbelt/dotfiles/issues)!

## Author

| [![twitter/mskblackbelt](https://secure.gravatar.com/avatar/c19070eaf142d30988084346ab6e693b)](http://twitter.com/mskblackbelt "Follow @mskblackbelt on Twitter") |
|---|

## Thanks to…

* @mathiasbynens and his [dotfiles repository](https://github.com/mathiasbynens/dotfiles)
