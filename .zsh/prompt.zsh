# Modified from af-magic.zsh-theme
# Repo: https://github.com/andyfleming/oh-my-zsh
# Direct Link: https://github.com/andyfleming/oh-my-zsh/blob/master/themes/af-magic.zsh-theme
# TERMWIDTH and PR_FILLBAR from http://aperiodic.net/phil/prompt/; 

function precmd {

  local TERMWIDTH
  (( TERMWIDTH = ${COLUMNS} - 1 ))


  ###
  # Truncate the path if it's too long.
  
  PR_FILLBAR=""
  PR_PWDLEN=""
  
  TOP_BAR_LENGTH=" pyenv:$(pyenv_prompt_info) $(battery_level_gauge)\
	  $(battery_time_remaining)"
  # Calculation for length of top prompt (from http://stackoverflow.com/q/10564314/2216427)
  local zero='%([BSUbfksu]|[FB]{*})' escape colno lineno
  FOOLENGTH=${#${(S%%)TOP_BAR_LENGTH//$~zero/}} 
	PR_FILLBAR="\${(l.($TERMWIDTH - $FOOLENGTH)..${PR_HBAR}.)}"
}

setopt extended_glob
preexec () {
    if [[ "$TERM" == "screen" ]]; then
	local CMD=${1[(wr)^(*=*|sudo|-*)]}
	echo -n "\ek$CMD\e\\"
    fi
}


function setprompt {
  ###
  # Need this so the prompt will work.

  setopt prompt_subst

  ###
  # See if we can use extended characters to look nicer.
  
  typeset -A altchar
  set -A altchar ${(s..)terminfo[acsc]}
  PR_SET_CHARSET="%{$terminfo[enacs]%}"
  PR_SHIFT_IN="%{$terminfo[smacs]%}"
  PR_SHIFT_OUT="%{$terminfo[rmacs]%}"
  PR_HBAR=${altchar[q]:--}
  PR_ULCORNER=${altchar[l]:--}
  PR_LLCORNER=${altchar[m]:--}
  PR_LRCORNER=${altchar[j]:--}
  PR_URCORNER=${altchar[k]:--}
	
  ###
  # See if we can use colors.

  autoload colors zsh/terminfo
  if [[ "$terminfo[colors]" -ge 8 ]]; then 
	  colors
  fi
  for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
	  eval PR_$color='%{$terminfo[bold]$fg[${(L)color}]%}'
	  eval PR_LIGHT_$color='%{$fg[${(L)color}]%}'
	  (( count = $count + 1 ))
  done
  PR_NO_COLOUR="%{$terminfo[sgr0]%}"
	
	
  if [ $UID -eq 0 ]; then NCOLOR="red"; else NCOLOR="green"; fi
  local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"
  
  # color vars
  eval PR_GREY='%{$FG[239]%}'
  eval PR_ORANGE='%{$FG[214]%}'
  
	###
    # Finally, the prompt.

#     PROMPT='$PR_CYAN$PR_SHIFT_IN$PR_ULCORNER$PR_BLUE$PR_HBAR$PR_SHIFT_OUT(\
# $PR_GREEN%(!.%SROOT%s.%n)$PR_GREEN@%m:%l$PR_BLUE)$PR_SHIFT_IN$PR_HBAR\
# $PR_CYAN$PR_HBAR${(e)PR_FILLBAR}$PR_BLUE$PR_HBAR$PR_SHIFT_OUT(\
# $PR_MAGENTA%$PR_PWDLEN<...<%~%<<$PR_BLUE)$PR_SHIFT_IN$PR_HBAR\
# $PR_CYAN$PR_URCORNER$PR_SHIFT_OUT\
#
#  $PR_CYAN$PR_SHIFT_IN$PR_LLCORNER$PR_BLUE$PR_HBAR$PR_SHIFT_OUT(\
#  %(?..$PR_LIGHT_RED%?$PR_BLUE:)\
#  ${(e)PR_APM}$PR_YELLOW%D{%H:%M}\
#  $PR_LIGHT_BLUE:%(!.$PR_RED.$PR_WHITE)%#$PR_BLUE)$PR_SHIFT_IN$PR_HBAR\
#  $PR_SHIFT_OUT$PR_CYAN$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT$PR_NO_COLOUR '
#
#     RPROMPT=' $PR_CYAN$PR_SHIFT_IN$PR_HBAR$PR_BLUE$PR_HBAR$PR_SHIFT_OUT\
# ($PR_YELLOW%D{%a,%b%d}$PR_BLUE)$PR_SHIFT_IN$PR_HBAR$PR_CYAN$PR_LRCORNER\
# $PR_SHIFT_OUT$PR_NO_COLOUR'
#
#     PS2='$PR_CYAN$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT\
# $PR_BLUE$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT(\
# $PR_LIGHT_GREEN%_$PR_BLUE)$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT\
# $PR_CYAN$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT$PR_NO_COLOUR '

    PROMPT='%{$PR_SHIFT_IN%}$PR_ULCORNER%{$PR_SHIFT_OUT%}%{$PR_GREY%} \
pyenv:$(pyenv_prompt_info) \
%{$PR_NO_COLOUR%}%{$PR_SHIFT_IN%}\
$PR_HBAR${(e)PR_FILLBAR}%{$PR_SHIFT_OUT%}\
$(battery_level_gauge)$(battery_time_remaining)\
%{$PR_SHIFT_IN%}$PR_URCORNER%{$PR_SHIFT_OUT%}\

%{$PR_SHIFT_IN%}$PR_LLCORNER%{$PR_SHIFT_OUT%} %{$FG[032]%}%~\
$(git_prompt_info) %{$FG[105]%}%(!.#.»)%{$PR_NO_COLOUR%} '

    RPROMPT=' $(virtualenv_prompt_info) %{$PR_GREY%}%n@%m %{$PR_NO_COLOUR%}\
%{$PR_SHIFT_IN%}$PR_LRCORNER%{$PR_SHIFT_OUT%}'

# RPROMPT='$(virtualenv_prompt_info)%{$PR_GRAY%}%n@%m"TESTING"%{$reset_color%}%'

    PS2='$PR_CYAN$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT\
$PR_BLUE$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT(\
$PR_LIGHT_GREEN%_$PR_BLUE)$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT\
$PR_CYAN$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT$PR_NO_COLOUR '

#   # primary prompt
#   PROMPT='%{$PR_GREY%}$PR_SHIFT_IN$PR_ULCORNER%{$PR_GREY%}\
# pyenv:$(pyenv_prompt_info)%{$reset_color%}${(e)PR_FILLBAR}\
# $(battery_level_gauge) $(battery_time_remaining)%{$reset_color%}
# %{$FG[032]%}%~$(git_prompt_info) %{$FG[105]%}%(!.#.»)%{$reset_color%} '
#
#   PS2=%_'%{$FG[red]%}:> %{$reset_color%}'
#
#   RPS1='${return_code}'

  
  # git settings
  ZSH_THEME_GIT_PROMPT_PREFIX="%{$FG[075]%}(git:"
  ZSH_THEME_GIT_PROMPT_CLEAN=""
  ZSH_THEME_GIT_PROMPT_DIRTY="%{${PR_ORANGE}%}*%{$reset_color%}"
  ZSH_THEME_GIT_PROMPT_SUFFIX="%{$FG[075]%})%{$reset_color%}"
}

setprompt