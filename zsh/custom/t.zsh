function _t() {
    python $HOME/dotfiles/script/t --task-dir ~/dotfiles/tasks --list tasks $@
}

function _pick_task {
    echo $(_t | fzf-tmux -d40% --ansi | perl -pe 's~^#\d+\s+- (.*?)\s+-.*~\1~')
}

function _refresh_and_push_tasks {
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
            git checkout master >/dev/null 2>&1
            git add tasks >/dev/null 2>&1
            git commit -m "Update tasks" >/dev/null 2>&1
            git push origin master >/dev/null 2>&1
        fi

        popd >/dev/null 2>&1
    fi
}

function t() {
    _t $@
    _refresh_and_push_tasks
}

function tf {
    _t -f $(_pick_task)
    _refresh_and_push_tasks
}

function tr {
    _t -r $(_pick_task)
    _refresh_and_push_tasks
}

function te {
    ID=$(_pick_task)

    if [[ ! -z $ID ]]; then
        NOTE=$(_t -n | grep "^#\d\+\s\+- $ID" | perl -pe "s~^#\d+\s+- $ID\s+- (.*)~\1~")
        TMP=$(mktemp -t "t-$ID")

        echo $NOTE > $TMP && ${EDITOR:-vim} $TMP

        NOTE=$(<$TMP)

        _t -e $ID "$NOTE"
    fi

    _refresh_and_push_tasks
}
