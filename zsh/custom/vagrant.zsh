function _vagrant_suspend_all {
    for box in $(vagrant global-status | grep running | cut -d ' ' -f1)
    do
        vagrant suspend $box
    done
}

function vagrant() {
    case $* in
        "suspend all") _vagrant_suspend_all ;;
        *) command vagrant "$@" ;;
    esac
}
