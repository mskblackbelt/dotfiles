## Python related exports
export PYENV_ROOT="$HOME/.pyenv"
# export PATH="$PYENV_ROOT/bin:$PATH"

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

  function pyenv_prompt_info() {
      echo "$(pyenv version-name)"
  }
fi

# Needed because `git` calls for `gettext.sh`, fails if pyenv has a shim for that.
export GIT_INTERNAL_GETTEXT_TEST_FALLBACKS=1

function pip_upgrade () {
  pip list --outdated --local --format=columns | tail -n +3 | cut -d ' ' -f1 | xargs -n1 pip install -U
  }

function pip2_upgrade () {
  pip2 list --outdated --local --format=columns | tail -n +3 | cut -d ' ' -f1 | xargs -n1 pip2 install -U
  }

function pip3_upgrade () {
  pip3 list --outdated --local --format=columns | tail -n +3 | cut -d ' ' -f1 | xargs -n1 pip3 install -U
  }


alias jpnb="jupyter notebook"
alias jplab="jupyter lab"