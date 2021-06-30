alias work="cd ~/Code"
alias dotfiles="cd ~/dotfiles"

# Ignore .retry ansible files
zstyle ':completion:*:*:nvim:*:*files' ignored-patterns '*.retry'

# Approve a dependabot PR, and instruct it to squash and merge.
function dbsm() {
    local repo="$1"
    local pr="$2"

    hub api "repos/acquia/$repo/pulls/$pr/reviews" \
        -f "body=@dependabot squash and merge" \
        -f "event=APPROVE"
}
