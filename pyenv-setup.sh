#!/usr/bin/env zsh
# Run this after all brews and casks have been installed

# Start Xquartz without launching xterm window
defaults write org.x.X11_launcher app_to_run /usr/bin/true

# Add Xquartz to startup applications
defaults write loginwindow AutoLaunchedApplicationDictionary -array-add '{ "Path" = "/Applications/Utilities/X11.app"; "Hide" = 0; }'

# To remove the dock icon while X11/XQuartz is active:
#
# Edit /usr/X11/X11.app/Contents/Info.plist
# Put in the lines just above the penultimate line that reads </dict>:
#     <key>LSUIElement</key>
#     <string>1</string>
#
# Save the changes. Then issue the following (1 line) command (may not work in OS X 10.6+):
#     /System/Library/Frameworks/ApplicationServices.framework/Versions/A\ /Frameworks/LaunchServices.framework/Versions/A/Support/lsregister \ -f /usr/X11/X11.app

# Ensure Homebrew formulae are updated
brew update

# Check for git install
hash git &> /dev/null
if [ $? -eq 1 ]; then
    echo 'Installing Git ...'
    brew install git
fi

#Check for gcc install
hash gcc &> /dev/null
if [ $? -eq 1 ]; then
    echo 'No gcc detected; Installing XCode Command Line Tools ...'
    xcode-select --install
fi

# Add science tap
brew tap homebrew/science

# Python virtualenv/pyenv setup
/usr/local/bin/pip install -U nose
/usr/local/bin/pip install -U six
/usr/local/bin/pip install -U python-dateutil
/usr/local/bin/pip install -U virtualenv
/usr/local/bin/pip install -U virtualenvwrapper
/usr/local/bin/pip install -U flake8
/usr/local/bin/pip install -U pygments
/usr/local/bin/pip install -U cython

# Pyenv installation
brew install pyenv
brew install pyenv-virtualenv
brew install pyenv-virtualenvwrapper
brew install pyenv-pip-rehash

# Scientific Python utilities
brew install postgresql
brew install sphinx
brew install zeromq
brew install openblas
brew install numpy
brew install scipy
ln -s /usr/local/include/freetype2/freetype/ /usr/local/include/freetype
brew install matplotlib