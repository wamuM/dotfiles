new_session(){
    if [ -z "$1" ];then
        echo "=========================================="
        echo " Tmux Session Picker "
        echo "=========================================="
        read -r -p "New session name (empty to quit): " name
        if [ ! -n "$name" ]; then
            exit 2
        fi
    else
        name="$1"
    fi
    tmux new-session -s "$name"\; send-keys "$HOME/.bashrc.d/scripts/welcome.sh" C-m
}

session_count="$(tmux has-session 2>/dev/null && tmux list-sessions | wc -l || echo 0)"

if (( $session_count == 0 ));then
    new_session
else
    input=$(
        {
            echo "+: New session"
            tmux list-sessions
        } | fzf --prompt="tmux> " --print-query
    )
    
    [ -z "$input" ] && exit 1
    
    count=$(echo "$input" | wc -l)
    if (( count == 2 ));then  
        choice="$(echo "$input" | head -n 2 | tail -n 1 )"
        if [[ "$choice" == "+: New session" ]]; then
            new_session
        else
            session_id="${choice%%:*}"
            if [ -n "$TMUX" ]; then
                tmux switch-client -t "$session_id"
            else
                tmux attach-session -t "$session_id"
            fi
    
        fi
    else 
        new_session $input
    fi
fi

# after tmux cleanup
xdotool set_window --name "terminal" "$WINDOWID"
