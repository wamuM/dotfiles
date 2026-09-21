# Edit config files

vff() {
    local p="${1:-.}"
    local file
    local status

    file=$(cd "$p" && fzf)

    local status=$?

    if (( $status != 0 )); then
        echo "fzf cancelled or failed (exit $status)"
        return "$status"
    fi

    nvim "$p/$file"
}

alias ven="vff ~/.config/nvim/"
