if ! { [ "$TERM" = "screen" ] && [ -n "$TMUX" ]; } then
    export FZF_TMUX=1
fi
