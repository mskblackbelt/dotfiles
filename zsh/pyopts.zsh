## Python related exports

## Set location for matplotlib config files
export MPLCONFIGDIR=$HOME/.matplotlib

### Functionality also provided by OMZ plugin `pyenv` 
# Auto-activate and enable pyenv and shims
if [[ $(which -a pyenv | grep -c 'bin/pyenv' 2> /dev/null) -gt 0 ]]; then
  eval "$(pyenv init --path)"
  eval "$(pyenv init - zsh)"
  
  export PYENV_ROOT="$HOME/.pyenv"
  # export PATH="$PYENV_ROOT/bin:$PATH"

  # Enable pyenv-virtualenv
  if (( $+commands[pyenv-virtualenv-init] )); then
    eval "$(pyenv virtualenv-init - zsh)"
  fi
  
  ## use pyenv instead of virtualenv for management of virtualenvs
  export PYENV_VIRTUALENVWRAPPER_PREFER_PYVENV="true"
  
  # Needed because `git` calls for `gettext.sh`, fails if pyenv has a shim for that.
  export GIT_INTERNAL_GETTEXT_TEST_FALLBACKS=1

  function pyenv_prompt_info() {
      echo "pyenv:$(pyenv version-name)"
  }

elif [[ $(which -a conda | grep -c 'bin/conda' 2> /dev/null) -gt 0]]; then
  function pyenv_prompt_info() {
    echo "conda:${CONDA_DEFAULT_ENV}"
  }
else
    # fallback to system python
    function pyenv_prompt_info() {
        echo "system($(python -V 2>&1 | cut -f 2 -d ' '))"
    }
fi


function pip_upgrade () {
  pip list --outdated --local | tail -n +3 | cut -d ' ' -f1 | xargs -n1 python -m pip install -U
  }
  
alias jpnb="jupyter notebook"
alias jplab="jupyter lab"
