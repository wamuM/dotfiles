#!/bin/env bash

alias tmux-picker="$HOME/.bashrc.d/scripts/tmux-picker.sh"

alert(){
    clear
    echo "================================================================================"
    echo "[WARNING] [WARNING] [WARNING] [WARNING] [WARNING] [WARNING] [WARNING] [WARNING] "
    echo " "
    echo " "
    echo "    You are not in a tmux session you can run 'tmux-picker' to choose one."
    echo " "
    echo " "
    echo "[WARNING] [WARNING] [WARNING] [WARNING] [WARNING] [WARNING] [WARNING] [WARNING] "
    echo "================================================================================"
}
alias suicide="touch ~/.suicide && tmux kill-session"
alias quit="tmux kill-session"


if [[ $- == *i* ]]; then
    if [ -z "$TMUX" ]; then
        clear
        tmux-picker 
        alert
        if [[ -f ~/.suicide ]]; then
            rm ~/.suicide
            exit
        fi
        echo "[WARNING] You are no longer in a tmux session, you can run 'tmux-picker' to choose one"
    fi
fi
