# checks (copied from zshuery)

if [[ -x $(which brew 2> /dev/null) ]]; then
    HAS_BREW=1
fi

if [[ -x $(which apt-get 2> /dev/null) ]]; then
    HAS_APT=1
fi

if [[ -x $(which yum 2> /dev/null) ]]; then
    HAS_YUM=1
fi

# Initialize PATH variable
if [[ $IS_MAC -eq 1 ]]; then
  unset PATH
  eval `/usr/libexec/path_helper -s`
fi

if [[ -d $HOME/.linuxbrew ]]; then
  eval $($HOME/.linuxbrew/bin/brew shellenv)
fi

if [[ -d /opt/homebrew ]]; then
  export PATH=/opt/homebrew/bin:$PATH
fi 

export PATH="$HOME/bin:$HOME/bin/anaconda/bin:$PATH"

# Path to the bash it configuration
export BASH_IT="$HOME/.bash_it"

# Lock and Load a custom theme file
# location /.bash_it/themes/
export BASH_IT_THEME='zork'

# (Advanced): Change this to the name of your remote repo if you
# cloned bash-it with a remote other than origin such as `bash-it`.
# export BASH_IT_REMOTE='bash-it'

# Don't check mail when opening terminal.
unset MAILCHECK

# Set this to false to turn off version control status checking within the prompt for all themes
export SCM_CHECK=true

# Set vcprompt executable path for scm advance info in prompt (demula theme)
# https://github.com/djl/vcprompt
#export VCPROMPT_EXECUTABLE=~/.vcprompt/bin/vcprompt

# Load Bash It
source $BASH_IT/bash_it.sh
