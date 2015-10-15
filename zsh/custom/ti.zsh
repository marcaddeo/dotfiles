function ti() {
    timetrap $@

    if [[ -n "$TMUX" ]]; then
        tmux refresh-client -S
    fi

    if [[ ! -z $(cd $HOME/dotfiles; git diff --name-only timetrap/) ]]; then
        pushd . >/dev/null
        cd $HOME/dotfiles

        if [[ ! -z $(cd $HOME/dotfiles; git diff --name-only | grep -v timetrap/) ]]; then
            echo "Cowardly refusing to auto-commit time sheets because the repository is dirty!"
        else
            echo "Pushing to Github..."
            git checkout master >/dev/null 2>&1
            git add timetrap >/dev/null 2>&1
            git commit -m "Update time sheets" >/dev/null 2>&1
            git push origin master >/dev/null 2>&1
        fi

        popd >/dev/null 2>&1
    fi
}

alias tio="ti out"
alias tid="ti display"
alias tit="ti today"
