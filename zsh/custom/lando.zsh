## Helper functions
function _is_lando_project() {
    local landos="$(lando list --format=json 2>/dev/null | jq -rM '.[].src[0]?[:-11]')"

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

    # This could conditionally decide if drush commands should redirect to
    # lando.

    true
}

function _composer_buffer_alter() {
    local buffer="$1"

    # If the buffer contains "example.com" change composer -> maestro before
    # redirecting to lando.
    if [[ "$(pwd)" = *"example.com"* ]]; then
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
        yarn
        wp
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

## Open Lando instances database in Querious
function qq() {
    local service="${1:-database}"
    if _is_lando_project; then
        open -u "$(lando info --format=json | jq -r '.[] | select(.service == "database") | "querious://connect/new?host=\(.external_connection.host)&port=\(.external_connection.port)&user=\(.creds.user)&password=\(.creds.password)&database=\(.creds.database)"')"
    fi
}
