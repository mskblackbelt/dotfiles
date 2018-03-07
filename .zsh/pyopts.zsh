## Python related exports
# export PYTHONPATH=/usr/local/lib
# export WORKON_HOME=$HOME/.virtualenvs
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

## use pyenv instead of virtualenv for management of virtualenvs
export PYENV_VIRTUALENVWRAPPER_PREFER_PYVENV="true"

## Set location for matplotlib config FILES
export MPLCONFIGDIR=$HOME/.matplotlib


## Auto-activate and enable pyenv and shims
if [[ $(which -a pyenv | grep -c 'bin/pyenv') -gt 0 ]]; then
  eval "$(pyenv init - zsh)"

  # Auto-activate pyenv-virtualenv
  if [[ $(pyenv commands | grep -c "virtualenv-init") -gt 0 ]]; then
    eval "$(pyenv virtualenv-init - zsh)"
  fi

  # # Auto-activate pyenv-virtualenvwrapper
  # if [[ $(pyenv commands | grep -c "virtualenvwrapper") -gt 0 ]]; then
  #   eval "$(pyenv virtualenvwrapper)"
  # fi

  function pyenv_prompt_info() {
      echo "$(pyenv version-name)"
  }
fi

alias pip_upgrade="pip list --outdated --local --format=columns | tail -n +3 | cut -d ' ' -f1 | xargs -n1 pip install -U"
alias pip2_upgrade="pip2 list --outdated --local --format=columns | tail -n +3 | cut -d ' ' -f1 | xargs -n1 pip2 install -U"
alias pip3_upgrade="pip3 list --outdated --local --format=columns | tail -n +3 | cut -d ' ' -f1 | xargs -n1 pip3 install -U"


alias jpnb="jupyter notebook"
alias jplab="jupyter lab"
