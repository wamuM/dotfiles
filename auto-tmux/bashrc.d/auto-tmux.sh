#!/bin/env bash
SESSION="main"
if [[ $- == *i* ]]; then
    if [ -z "$TMUX" ]; then
        if ! tmux has-session -t "$SESSION" 2>/dev/null; then
            tmux new -s "$SESSION" \; send-keys "$HOME/.bashrc.d/scripts/welcome.sh" C-m
        else
            tmux attach -t "$SESSION"
        fi
    fi
fi
