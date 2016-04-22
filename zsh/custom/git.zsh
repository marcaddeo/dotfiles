# Override the glg alias to be more informative
alias glg="git log --graph --pretty=format:'%Cred%h%Creset %C(bold yellow)[%G?]%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset %C(bold blue)' --abbrev-commit --date=relative"
alias gc="git commit -e -v"

function gcd {
    if [[ ! -z $(git branch | grep development) ]]; then
        git checkout development
    elif [[ ! -z $(git branch | grep develop) ]]; then
        git checkout develop
    else
        echo "Could not find a \`development\` or \`develop\` branch"
    fi
}
