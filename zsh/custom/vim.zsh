# Alias vim to nvim
alias vim="nvim"
alias vi="nvim"

# Set my default editor to vim
export EDITOR="nvim"
export VISUAL="nvim"

function v {
    FILE=$(fzf-tmux -d40% --ansi --tac)
    vim $FILE
}
