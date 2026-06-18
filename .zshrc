eval "$(starship init zsh)"


if [[ -n $PS1 ]]; then
    fastfetch
fi



alias ls='eza --icons --color=auto'
alias cat='bat'
alias find='fd'
alias dir='tree'


