#!/bin/sh

# Install Homebrew (Xcode Command Line Tools must be installed first)
hash brew &> /dev/null
if [ $? -eq 1 ]; then
    echo 'Installing Homebrew ...'
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

cd "${HOME}/dotfiles"

# Install Homebrew Casks and CLI tools
./brew-installs

# Run script to configure misc. OS X and application settings
./.osx

# Add Bash 4 and Zsh 5 (from Homebrew) to `/etc/shells`
sudo sh -c 'echo "/usr/local/bin/bash\n/usr/local/bin/zsh" >> /etc/shells'