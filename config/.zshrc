eval "$(starship init zsh)"

if [[ -n $PS1 ]]; then
    fastfetch
fi

print -P "%F{cyan} Greetings Ribhav!%f Today's date is: %F{magenta}$(date)%f, you are in directory:%F{green}$(pwd)%f. Here is a list of all your USB devices(just in case):%F{blue}$(lsusb)%f"
alias ls='eza --icons --color=auto'
alias cat='bat'
alias find='fd'
alias dir='tree'
alias commit='/home/ribhav/.local/bin/backup-config.sh'

