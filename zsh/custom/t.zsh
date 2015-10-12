# Refresh the tmux display every time we run a t command so that our task count
# in the status bar is updated immediately
function t() {
    python $HOME/dotfiles/script/t --task-dir ~/tasks --list tasks $@

    if [[ -n "$TMUX" ]]; then
        tmux refresh-client -S
    fi

    if [[ ! -z $(git diff --name-only $HOME/tasks/tasks) ]]; then
        pushd .
        cd $HOME/dotfiles

        if ! git diff --exit-code --quiet; then
            echo "Cowardly refusing to auto-commit tasks because the repository is dirty\!"
        else
            git checkout master
            git add tasks/tasks
            git commit -m "Update tasks"
            git push origin master
        fi

        popd
    fi
}
