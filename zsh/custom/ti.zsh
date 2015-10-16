function _refresh_and_push_timesheetss {
    if [[ -n "$TMUX" ]]; then
        tmux refresh-client -S
    fi

    if [[ ! -z $(cd $HOME/dotfiles/timetrap/sheets; git diff --name-only) ]]; then
        pushd . >/dev/null
        cd $HOME/dotfiles/timetrap/sheets

        echo "Pushing to Github..."
        git checkout master >/dev/null 2>&1
        git add timetrap >/dev/null 2>&1
        git commit -m "Update time sheets" >/dev/null 2>&1
        git push origin master >/dev/null 2>&1

        popd >/dev/null 2>&1
    fi
}

function ti() {
    timetrap $@
    _refresh_and_push_timesheetss
}

function tie {
    ID=$(timetrap display -v | grep -v "^ " | tail -n+3 | fzf-tmux -d40% --ansi --tac | cut -d ' ' -f1)

    if [[ ! -z $ID ]]; then
        NOTE=$(timetrap display -fjson_all | jq -r ".[] | select(.id==$ID) | .note")
        TMP=$(mktemp -t "ti-$ID")

        echo $NOTE > $TMP && ${EDITOR:-vim} $TMP

        NOTE=$(<$TMP)

        timetrap edit --id $ID "$NOTE"
    fi

    _refresh_and_push_timesheetss
}

function tik {
    ID=$(timetrap display -v | grep -v "^ " | tail -n+3 | fzf-tmux -d40% --ansi --tac | cut -d ' ' -f1)

    if [[ ! -z $ID ]]; then
        timetrap kill --id $ID
    fi

    _refresh_and_push_timesheetss
}

alias tio="ti out"
alias tid="ti display"
alias tit="ti today"
