alias work="cd ~/dev/oomph"
alias dotfiles="cd ~/dotfiles"
alias php5="brew unlink php72; brew link --force php@5.6"
alias php7="brew unlink php@5.6; brew link php72"

# Ignore .retry ansible files
zstyle ':completion:*:*:nvim:*:*files' ignored-patterns '*.retry'

function dsf() {
    diff -u "$@" | diff-so-fancy
}
