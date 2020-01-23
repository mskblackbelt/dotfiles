function set_running_app {
  printf "\e]1; $PWD:t:$(history $HISTCMD | cut -b7- ) \a"
}

## Set in prompt.zsh
# function preexec {
#   set_running_app
# }

function postexec {
  set_running_app
}
