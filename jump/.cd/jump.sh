usage(){
    echo "[?] Usage: jump <alias>" 
    echo "    where <alias> is the name of a symlink in $JUMP_DIR"
    echo "    you can also do"
    echo "    jump add <dir> <alias>    to add an alias"
    echo "    jump remove <alias>       to remove an alias"
    echo "    jump list                 to list all the aliases"
}

if [[ $# -eq 1 ]];then
    if [[ "$1" == "list" ]];then
        echo "[=] list of aliases:"
        for f in "$JUMP_DIR"/*;do
            if [[ -L "$f"  ]]; then
                echo "$(basename "$f") : $(readlink "$f")"
            fi
        done
    elif [[ -e "$JUMP_DIR/$1" ]];then
        cd "$(readlink "$JUMP_DIR/$1")"
    else 
        echo "[!] Fatal: The cd alias doesn't exist"
        usage
    fi
elif [[ $# -ge 2 ]];then
    if [[ "$1" == "add" ]];then
        if [[ -d "$2" ]];then
            if [[ -e "$JUMP_DIR/$3" ]];then
                echo "[!] Fatal: the <alias>($3) already exists, remove it first"
                usage
            elif [[ "$3" == "add" || "$3" == "remove" || "$3" == "list" ]];then
                echo "[!] Fatal: the <alias>($3) is a forbidden name, please use something else."
            else
                ln -s "$(realpath "$2")" "$JUMP_DIR/$3"
		        echo "[=] Alias '$3' to '$(realpath $2)' successfully created"
            fi
        else
            echo "[!] <dir>($2) needs to be a directory"
            usage
        fi
    elif [[ "$1" == "remove" ]];then
        if [[ -L "$JUMP_DIR/$2" ]];then
            rm "$JUMP_DIR/$2"
            echo "[=] Alias '"$2"' removed"
        else
            echo "[-] Nothing done: The cd alias doesn't exist"
            usage
        fi
    else
        echo "[!] Fatal: The cd subcommand doesn't exist"
        usage
    fi
else
    echo "[!] Fatal: no command provided"
    usage
fi
