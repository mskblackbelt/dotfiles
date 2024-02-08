###########################################
# Battery plugin for oh-my-zsh            #
# Original Author: Peter hoeg (peterhoeg) #
# Email: peter@speartail.com              #
###########################################
# Author: Sean Jones (neuralsandwich)     #
# Email: neuralsandwich@gmail.com         #
# Modified to add support for Apple Mac   #
###########################################

function battery_level_gauge() {
  local gauge_slots=${BATTERY_GAUGE_SLOTS:-10};
  local green_threshold=${BATTERY_GREEN_THRESHOLD:-6};
  local yellow_threshold=${BATTERY_YELLOW_THRESHOLD:-4};
  local color_green=${BATTERY_COLOR_GREEN:-%F{green}};
  local color_yellow=${BATTERY_COLOR_YELLOW:-%F{yellow}};
  local color_red=${BATTERY_COLOR_RED:-%F{red}};
  local color_reset=${BATTERY_COLOR_RESET:-%{%f%k%b%}};
  local battery_prefix=${BATTERY_GAUGE_PREFIX:-'['};
  local battery_suffix=${BATTERY_GAUGE_SUFFIX:-']'};
  local filled_symbol=${BATTERY_GAUGE_FILLED_SYMBOL:-'❚'};
  local empty_symbol=${BATTERY_GAUGE_EMPTY_SYMBOL:-'☐'};
  local charging_color=${BATTERY_CHARGING_COLOR:-$color_yellow};
  # local charging_symbol=${BATTERY_CHARGING_SYMBOL:-' ⚡️ '};
  local charging_symbol=${BATTERY_CHARGING_SYMBOL:-'⚡︎'};
  local charged_symbol=${BATTERY_CHARGED_SYMBOL:-' ⏚ '};

  local battery_remaining_percentage=$(battery_pct_remaining);

  if [[ $battery_remaining_percentage =~ [0-9]+ ]]; then
    local filled=$(((( $battery_remaining_percentage + $gauge_slots - 1) / $gauge_slots)));
    local empty=$(($gauge_slots - $filled));

    if [[ $filled -gt $green_threshold ]]; then 
      local gauge_color=$color_green;
    elif [[ $filled -gt $yellow_threshold ]]; then 
      local gauge_color=$color_yellow;
    else 
      local gauge_color=$color_red;
    fi
  else
    local filled=$gauge_slots;
    local empty=0;
    filled_symbol=${BATTERY_UNKNOWN_SYMBOL:-'.'};
  fi

  local charging=' '
  if battery_is_charging; then
    charging=$charging_symbol
  elif battery_charged; then
    charging=$charged_symbol
  fi
  

  printf ${charging_color//\%/\%\%}$charging${color_reset//\%/\%\%}${battery_prefix//\%/\%\%}${gauge_color//\%/\%\%}
  printf ${filled_symbol//\%/\%\%}'%.0s' {1..$filled}
  [[ $filled -lt $gauge_slots ]] && printf ${empty_symbol//\%/\%\%}'%.0s' {1..$empty}
  printf ${color_reset//\%/\%\%}${battery_suffix//\%/\%\%}${color_reset//\%/\%\%}
}


if [[ "IS_MAC" -eq 1 ]] && [[ $(pmset -g batt | grep -c "Batt") -gt 0 ]]; then
	
  function battery_pct() {
    pmset -g batt | grep -o "\d*%" | tr -d "%"
    # local smart_battery_status="$(ioreg -rc "AppleSmartBattery")"
    # typeset -F maxcapacity=$(echo $smart_battery_status | grep '^.*"MaxCapacity"\ =\ ' | sed -e 's/^.*"MaxCapacity"\ =\ //')
    # typeset -F currentcapacity=$(echo $smart_battery_status | grep '^.*"CurrentCapacity"\ =\ ' | sed -e 's/^.*CurrentCapacity"\ =\ //')
    # integer i=$(((currentcapacity/maxcapacity) * 100))
    # echo $i
  }

  function plugged_in() {
    [[ $(pmset -g batt | grep -c "Now drawing from 'AC Power'") -eq 1 ]]
  }
  
  function battery_is_charging() {
    [[ $(ioreg -rc "AppleSmartBattery"| grep '^.*"IsCharging" = ' | sed -e 's/^.*"IsCharging"\ =\ //') == "Yes" ]]
  }
  
  function battery_charged() {
    [[ $(pmset -g batt | grep -c " charged") -eq 1 ]]
  }

  function battery_pct_remaining() {
    if plugged_in ; then
      echo "External Power"
    else
      battery_pct
    fi
  }

  function battery_time_remaining() {
    if [[ $(pmset -g batt | grep -c " discharging") -eq 1 ]] ; then
      echo " $(pmset -g batt | grep -o "[0-9]*:[0-9]* remaining" | \
		  cut -f1 -d ' ')"
    else
      if [[ $(pmset -g batt | grep -c " charging") -eq 1 ]]; then 
        echo " $(pmset -g batt | grep -o "[0-9]*:[0-9]* remaining" | \
			cut -f1 -d ' ')"
      fi
    fi
  }
  
  
  function battery_pct_prompt () {
    if [[ $(ioreg -rc AppleSmartBattery | grep -c '^.*"ExternalConnected"\ =\ No') -eq 1 ]] ; then
      b=$(battery_pct_remaining)
      if [ $b -gt 50 ] ; then
        color='green'
      elif [ $b -gt 20 ] ; then
        color='yellow'
      else
        color='red'
      fi
      echo "%{$fg[$color]%}[$(battery_pct_remaining)%%]%{$reset_color%}"
    else
      echo "∞"
    fi
  }



elif [[ $(uname) == "Linux" ]] && [[ _command_exists upower ]] && [[ $(upower -e | grep -i -c "battery") -ge 1 ]] ; then

	  local battery_name=$(upower -e | grep "battery")
	  local adapter_name=$(upower -e | grep "line_power")
	  local display_device=$(upower -e | grep "DisplayDevice")
  
	  function battery_is_charging() {
	    [[ $(upower -i $display_device | grep -c ' charging') -gt 0 ]]
	  }
  
	  function battery_is_discharging() {
	    [[ $(upower -i $display_device | grep -c 'discharging') -gt 0 ]]
	  }
  
	   function battery_charged() {
	    [[ $(upower -i $display_device | grep "state" | grep -c "fully-charged") -eq 1 ]]
	  }

	  function battery_pct() {
	    upower -i $display_device | grep "percentage" | cut -d ":" -f2 | sed -e 's/^\s*//' | tr -d "%"
	  }

	  function battery_pct_remaining() {
	    if [ ! $(battery_is_charging) ] ; then
	      battery_pct
	    else
	      echo "External Power"
	    fi
	  }

	  function battery_time_remaining() {
	    if [[ $(upower -i $display_device | grep -c "discharging") -gt 0 ]] ; then
	      echo "$(upower -i $display_device | grep "time to empty" | cut -d ":" -f2 | sed -e 's/^\s*//')"
	    fi
	  }

	  function battery_pct_prompt() {
	    b=$(battery_pct_remaining) 
	    if [[ $(battery_is_discharging) ]] ; then
	      if [ $b -gt 50 ] ; then
	        color='green'
	      elif [ $b -gt 20 ] ; then
	        color='yellow'
	      else
	        color='red'
	      fi
	      echo "%{$fg[$color]%}[$(battery_pct_remaining)%%]%{$reset_color%}"
	    else
	      echo "∞"
	    fi
	  }

else
  # Empty functions so we don't cause errors in prompts
  function battery_pct_remaining() {
  }

  function battery_time_remaining() {
  }

  function battery_pct_prompt() {
  }
  
  function battery_is_charging() {
  }
  
  function battery_level_gauge() {
  }
fi



