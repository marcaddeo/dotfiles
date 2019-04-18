## Helper functions
function _is_lando_project() {
    local landos="$(lando list --format=json | jq -rM 'del(._global_) | .[][0].src[0][:-11]')"

    for lando in ${(f)landos}; do
        [[ "$(pwd)" = "$lando"* ]] && return
    done

    false
}

function _function_exists() {
    declare -f -F $1 > /dev/null
    return $?
}

function _hook_execute() {
    local hook_name="$1"

    if _function_exists "$hook_name"; then
        "$hook_name" "${@:2}"
    fi

    true
}

function _alter_execute() {
    local alter_name="$1"

    if _function_exists "$alter_name"; then
        echo "$("$alter_name" "${@:2}")"
        return
    fi

    echo "${@:2}"
}

## Hooks and alters
function _drush_should_redirect() {
    local drush_command="$1"

    # @TODO make this not redirect if there's a site alias involved
    true
}

function _composer_buffer_alter() {
    local buffer="$1"

    if [[ "$(pwd)" = *"bcbs.com"* ]]; then
        buffer="${buffer/composer/maestro}"
    fi

    echo "$buffer"
}

## The core redirection logic
function _lando_zsh_buffer_alter() {
    local lando_commands=(
        drush
        composer
        phpunit
        behat
        phpcs
        npm
        gulp
    )

    for command in "$lando_commands[@]"; do
        if [[ "$BUFFER" == "$command"* ]]; then
            if ! _hook_execute "_${command}_should_redirect" "$BUFFER"; then
                break
            fi

            if _is_lando_project; then
                BUFFER="lando $BUFFER"
            else
                break
            fi

            BUFFER=$(_alter_execute "_${command}_buffer_alter" "$BUFFER")
        fi
    done

    zle .accept-line
}
zle -N accept-line _lando_zsh_buffer_alter
