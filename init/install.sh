#!/bin/bash

cd "$(dirname "${BASH_SOURCE}")";

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `install.sh` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

## Install all homebrew packages inside Brewfile

# Check for Homebrew Installation
if ! which brew > /dev/null; then
    # Install Homebrew
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi;

# Add Homebrew to path
export PATH=/opt/homebrew/bin:$PATH

# Update Homebrew
brew update

# Upgrade any already-installed formulae.
brew upgrade

# Install current ZShell from Homebrew
brew install zsh

# Install rcm and git
brew install git rcm

# Switch to using brew-installed zsh as default shell
if ! fgrep -q '/opt/homebrew/bin/zsh' /etc/shells; then
 echo '/opt/homebrew/bin/zsh' | sudo tee -a /etc/shells;
 chsh -s /opt/homebrew/bin/zsh;
fi;

# Remove outdated versions from the cellar.
brew cleanup

# Update dotfiles repository
git pull origin main

# Initialize and pull submodules
git submodule init
git submodule update --recursive

# Install rc files using rcm
RCRC="../rcrc"; rcup

echo "Run macos_install.sh to set up additonal MacOS options."
echo "Run 'brew bundle --file ./init/Brewfile' to install all Homebrew formulae."