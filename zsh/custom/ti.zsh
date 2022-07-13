function _refresh_and_push_timesheetss {
    if [[ -n "$TMUX" ]]; then
        tmux refresh-client -S
    fi

    if [[ ! -z $(cd $HOME/dotfiles/timetrap/sheets; git diff --name-only) ]]; then
        pushd . >/dev/null
        cd $HOME/dotfiles/timetrap/sheets

        echo "Pushing to Github..."
        git checkout master >/dev/null 2>&1
        git add . >/dev/null 2>&1
        git commit --no-gpg-sign -m "Update time sheets" >/dev/null 2>&1
        git push origin master >/dev/null 2>&1

        popd >/dev/null 2>&1
    fi
}

function _pick_entry {
    echo $(timetrap display -v | grep -v "^ " | tail -n+3 | fzf-tmux -d40% --ansi --tac | cut -d ' ' -f1)
}

function ti() {
    timetrap $@
    _refresh_and_push_timesheetss
}

function tii() {
    timetrap in $@
    _refresh_and_push_timesheetss
}

function tie() {
    ID=$(_pick_entry)

    if [[ ! -z $ID ]]; then
        NOTE=$(timetrap display -fjson_all | jq -r ".[] | select(.id==$ID) | .note")
        TMP=$(mktemp -t "ti-$ID")

        echo $NOTE > $TMP && ${EDITOR:-vim} $TMP

        NOTE=$(<$TMP)

        timetrap edit --id $ID "$NOTE" $@
    fi

    _refresh_and_push_timesheetss
}

function tik {
    ID=$(_pick_entry)

    if [[ ! -z $ID ]]; then
        timetrap kill --id $ID
    fi

    _refresh_and_push_timesheetss
}

function tir() {
    ID=$(_pick_entry)

    if [[ ! -z $ID ]]; then
        timetrap resume --id $ID $@
    fi

    _refresh_and_push_timesheetss
}

function tire() {
    ID=$(_pick_entry)

    if [[ ! -z $ID ]]; then
        timetrap resume --id $ID $@

        NOTE=$(timetrap display -fjson_all | jq -r ".[] | select(.id==$ID) | .note")
        TMP=$(mktemp -t "ti-$ID")

        echo $NOTE > $TMP && ${EDITOR:-vim} $TMP

        NOTE=$(<$TMP)

        timetrap edit "$NOTE" $@
    fi

    _refresh_and_push_timesheetss
}

function tij() {
    php $HOME/dotfiles/script/timetrap-to-jira/timetrap-to-jira.php $@
}

function tib() {
    BRANCH=$(git rev-parse --abbrev-ref HEAD)
    KEY=$(echo $BRANCH | cut -d '/' -f1)
    NOTE=$(echo $BRANCH | cut -d '/' -f2- | sed -e 's/-/ /g')

    timetrap in "$KEY $NOTE" $@

    _refresh_and_push_timesheetss
}

function titot() {
    SECS=$(timetrap display -fjira "${@:2}" | grep "$1" | perl -pe 's/.* (\d+:\d+:\d+) .*/\1/' | sed 's/:/*60+/g;s/*60/&&/' | bc | paste -sd+ - | bc)
    echo - | awk -v "S=$SECS" '{printf "%02d:%02d:%02d\n", S/(60*60), S%(60*60)/60, S%60}'
}

alias tio="ti out"
alias tid="ti display"
alias tit="ti today"
alias tiw="ti week"
