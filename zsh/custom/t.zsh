# Refresh the tmux display every time we run a t command so that our task count
# in the status bar is updated immediately
function t() {
    python $HOME/dotfiles/script/t --task-dir ~/tasks --list tasks $@
    tmux refresh-client -S
}
