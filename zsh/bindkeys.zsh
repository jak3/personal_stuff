# To see the key combo you want to use just do:
# cat > /dev/null
# And press it

bindkey -v

# bind k and j for VI mode
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

# Upper K and J for normal history search
bindkey -a 'K' up-line-or-history
bindkey -a 'J' down-line-or-history
