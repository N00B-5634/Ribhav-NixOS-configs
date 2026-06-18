eval "$(starship init zsh)"


if [[ -n $PS1 ]]; then
    fastfetch
fi

alias nix-switch="git add -A && sudo nixos-rebuild switch --flake .#nixos-laptop"
alias nix-clean="sudo nix-env --delete-generations old && sudo nix-store --gc"
alias ls="eza --icons --color=auto"
alias cat="bat"
 alias find="fd"
 alias dir="tree"


