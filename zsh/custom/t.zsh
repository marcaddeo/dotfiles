# Refresh the tmux display every time we run a t command so that our task count
# in the status bar is updated immediately
function t() {
    python $HOME/dotfiles/script/t --task-dir ~/tasks --list tasks $@

    if [[ -n "$TMUX" ]]; then
        tmux refresh-client -S
    fi

    if [[ ! -z $(cd $HOME/dotfiles; git diff --name-only tasks/) ]]; then
        pushd . >/dev/null
        cd $HOME/dotfiles

        if [[ ! -z $(cd $HOME/dotfiles; git diff --name-only | grep -v tasks/) ]]; then
            echo "Cowardly refusing to auto-commit tasks because the repository is dirty!"
        else
            echo "Pushing to Github..."
            git checkout master >>/dev/null
            git add tasks >>/dev/null
            git commit -m "Update tasks" >>/dev/null
            git push origin master >>/dev/null
        fi

        popd >/dev/null
    fi
}
