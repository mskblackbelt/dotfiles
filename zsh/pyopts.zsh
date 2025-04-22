## Python related exports

## Set location for matplotlib config files
export MPLCONFIGDIR=$XDG_CONFIG_HOME/matplotlib

### Functionality also provided by OMZ plugin `pyenv` 
# Auto-activate and enable pyenv and shims
if _command_exists pyenv; then
  eval "$(pyenv init --path)"
  eval "$(pyenv init - zsh)"
  
  export PYENV_ROOT="$HOME/.pyenv"
  # export PATH="$PYENV_ROOT/bin:$PATH"

  # Enable pyenv-virtualenv
  if _command_exists pyenv-virtualenv-init; then
    eval "$(pyenv virtualenv-init - zsh)"
  fi
  
  ## use pyenv instead of virtualenv for management of virtualenvs
  export PYENV_VIRTUALENVWRAPPER_PREFER_PYVENV="true"
  
  # Needed because `git` calls for `gettext.sh`, fails if pyenv has a shim for that.
  export GIT_INTERNAL_GETTEXT_TEST_FALLBACKS=1

  function python_prompt_info() {
      echo "pyenv:$(pyenv version-name)"
  }

### UV setup

elif _command_exists uv; then  
  function python_prompt_info() {
    echo "uv:$(python -V 2>&1 | cut -f 2 -d ' ')"
  }

elif _command_exists conda; then
  function python_prompt_info() {
    echo "conda:$(python -V 2>&1 | cut -f 2 -d ' ')"
  }
else
  # fallback to system python
  function python_prompt_info() {
      echo "system($(python -V 2>&1 | cut -f 2 -d ' '))"
  }
fi

if _command_exists pixi; then
  export PIXI_HOME=$XDG_CONFIG_HOME/pixi
fi 

function pip_upgrade () {
  pip list --outdated --local | tail -n +3 | cut -d ' ' -f1 | xargs -n1 python -m pip install -U
  }
  
alias jpnb="jupyter notebook"
alias jplab="jupyter lab"


