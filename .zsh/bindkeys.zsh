# To see the key combo you want to use just do:
# cat > /dev/null
# And press it

# bindkey "^U"      kill-whole-line                      # ctrl-u
# bindkey "^K"      kill-to-end-of-line                  # ctrl-k
# bindkey "^[W"     kill-to-beginning-of-line            # meta-w
# bindkey "^R"      history-incremental-search-backward  # ctrl-r
# bindkey "^A"      beginning-of-line                    # ctrl-a
# bindkey "^E"      end-of-line                          # ctrl-e
# bindkey "[B"      history-search-forward               # down arrow
# bindkey "[A"      history-search-backward              # up arrow
# bindkey "^D"      delete-char                          # ctrl-d
# bindkey "^F"      forward-char                         # ctrl-f
# bindkey "^B"      backward-char                        # ctrl-b
# bindkey "^[F"     forward-word                         # meta-f
# bindkey "^[B"     backward-word                        # meta-b

bindkey -e   # Default to standard emacs bindings, regardless of editor string
bindkey '^x^e' edit-command-line
bindkey '^xe' edit-command-line