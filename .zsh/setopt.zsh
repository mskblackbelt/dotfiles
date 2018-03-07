# ===== Basics

# If you type foo, and it isn't a command, and it is a directory in your cdpath, go there
setopt AUTO_CD

# Don't push duplicate entries to stack with pushd
setopt PUSHD_IGNORE_DUPS

# Allow comments even in interactive shells (especially for Muness)
setopt INTERACTIVE_COMMENTS

# Do not exit shell on end-of-file (ten consecutive EOF calls will still force the shell to exit)
setopt IGNORE_EOF

# List jobs in long format by default
setopt LONG_LIST_JOBS

# ===== History

# Allow multiple terminal sessions to all append to one zsh command history
setopt APPEND_HISTORY 

# Add comamnds as they are typed, don't wait until shell exit
setopt INC_APPEND_HISTORY 

# Do not write events to history that are duplicates of previous events
setopt HIST_IGNORE_ALL_DUPS

# When searching history don't display results already cycled through twice
setopt HIST_FIND_NO_DUPS

# Remove extra blanks from each command line being added to history
setopt HIST_REDUCE_BLANKS

# Remove history entries when the first character is a space or when the expanded alias contains a leading space
setopt HIST_IGNORE_SPACE

# Include more information about when the command was executed, etc
setopt EXTENDED_HISTORY

# Share the history file between multiple shells
setopt SHARE_HISTORY

# ===== Completion 

# Allow completion from within a word/phrase
setopt COMPLETE_IN_WORD 

# When completing from the middle of a word, move the cursor to the end of the word
setopt ALWAYS_TO_END

# Automatically list options on an ambiguous completion
setopt AUTO_LIST

# ===== Prompt

# Enable parameter expansion, command substitution, and arithmetic expansion in the prompt
setopt PROMPT_SUBST

# Display red dots while waiting for completion
COMPLETION_WAITING_DOTS="true"

unsetopt MENU_COMPLETE
setopt AUTO_MENU
