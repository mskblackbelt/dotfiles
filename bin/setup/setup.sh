#!/bin/sh

# Install Homebrew (Xcode Command Line Tools must be installed first)
xcode-select --install 
hash brew &> /dev/null
if [ $? -eq 1 ]; then
    echo 'Installing Homebrew ...'
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

cd "${HOME}/dotfiles"

# Link iCloud Drive and Projects folders to user home folder
ln -s "${HOME}/Library/Mobile Documents/com~apple~CloudDocs/iCloud Drive" ${HOME}/"iCloud Drive"
ln -s "${HOME}/iCloud Drive/Projects" "${HOME}/Projects"

# Install rcm, pull dotfiles from git, link to home folder
brew install rcm
if [ -e "${HOME}/Projects/dotfiles/rcrc" ] && [ -x $(which rcup) ]; then
  env RCRC="${HOME}/Projects/dotfiles/rcrc"
  echo "Linking dotfiles ..."
  rcup
fi 

# Install Homebrew Casks and CLI tools
brew bundle --file "${HOME}/Projects/dotfiles/Brewfile"

# Run script to configure misc. macOS and application settings
./macos.sh

# Add Homebrew versions of Bash and Zsh to `/etc/shells`
sudo sh -c 'echo "/opt/local/bin/bash\n/opt/local/bin/zsh" >> /etc/shells'

# Open Setapp to install the remainder of the applications
open -a Setapp