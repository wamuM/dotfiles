#!/usr/bin/env bash

: "${DRAWER_DIR:=$HOME/.drawer}"


drawer() {
    local command="${1:-help}"
    local target="${2:-}"
    local drawers=()
    local drawer=""
    local latest=""
    local index=""
    local choice=""
    local answer=""
    local count=0
    local total=0
    local item=""
    local resolved=""

    case "$command" in

        # ----------------------------------------------------------------------
        # SHOVE
        # ----------------------------------------------------------------------
        shove|s)
            local stamp

            mkdir -p "$DRAWER_DIR"

            stamp=$(date +"%Y-%m-%d_%H-%M-%S-%3N")
            drawer="$DRAWER_DIR/drawer-${stamp}_${RANDOM}"

            mkdir -p "$drawer"

            shopt -s dotglob nullglob
            mv "$HOME/Desktop"/* "$drawer/" 2>/dev/null
            shopt -u dotglob nullglob

            mkdir -p "$HOME/Desktop"

            ln -sfn "$drawer" "$DRAWER_DIR/drawer"

            echo "Dumped all desktop contents to:"
            echo "  $drawer"
            echo
            echo "Use 'drawer open' to open it."
            ;;


        # ----------------------------------------------------------------------
        # LIST
        # ----------------------------------------------------------------------
        list|l)
            mapfile -t drawers < <(
                find "$DRAWER_DIR" \
                    -maxdepth 1 \
                    -mindepth 1 \
                    -type d \
                    -name "drawer-*" \
                    -print 2>/dev/null |
                    sort -r
            )

            total="${#drawers[@]}"

            if [ "$total" -eq 0 ]; then
                echo "No drawers found."
                return
            fi

            latest="${drawers[0]}"

            echo "Drawers:"
            echo

            for drawer in "${drawers[@]}"; do
                count=$((count + 1))

                if [ "$drawer" = "$latest" ]; then
                    printf '  %2d  %s  (latest)\n' \
                        "$count" \
                        "$(basename "$drawer")"
                else
                    printf '  %2d  %s\n' \
                        "$count" \
                        "$(basename "$drawer")"
                fi
            done
            ;;


        # ----------------------------------------------------------------------
        # OPEN
        # ----------------------------------------------------------------------
        open|o)
            mapfile -t drawers < <(
                find "$DRAWER_DIR" \
                    -maxdepth 1 \
                    -mindepth 1 \
                    -type d \
                    -name "drawer-*" \
                    -print 2>/dev/null |
                    sort -r
            )

            total="${#drawers[@]}"

            if [ "$total" -eq 0 ]; then
                echo "No drawers found."
                return 1
            fi

            # No argument = latest.
            if [ -z "$target" ]; then
                resolved="${drawers[0]}"

            # Numeric argument = index.
            elif [[ "$target" =~ ^[0-9]+$ ]]; then
                index=$((target - 1))

                if [ "$index" -lt 0 ] || [ "$index" -ge "$total" ]; then
                    echo "Invalid drawer index: $target"
                    return 1
                fi

                resolved="${drawers[$index]}"

            # Otherwise = drawer name.
            else
                resolved="$DRAWER_DIR/$target"

                if [ ! -d "$resolved" ] ||
                   [[ "$(basename "$resolved")" != drawer-* ]]; then
                    echo "Drawer not found: $target"
                    return 1
                fi
            fi

            cd "$resolved" || return 1
            ;;


        # ----------------------------------------------------------------------
        # RESTORE
        # ----------------------------------------------------------------------
        restore|r)
            mapfile -t drawers < <(
                find "$DRAWER_DIR" \
                    -maxdepth 1 \
                    -mindepth 1 \
                    -type d \
                    -name "drawer-*" \
                    -print 2>/dev/null |
                    sort -r
            )

            total="${#drawers[@]}"

            if [ "$total" -eq 0 ]; then
                echo "No drawers found."
                return 1
            fi

            # No argument = latest.
            if [ -z "$target" ]; then
                resolved="${drawers[0]}"

            # Numeric argument = index.
            elif [[ "$target" =~ ^[0-9]+$ ]]; then
                index=$((target - 1))

                if [ "$index" -lt 0 ] || [ "$index" -ge "$total" ]; then
                    echo "Invalid drawer index: $target"
                    return 1
                fi

                resolved="${drawers[$index]}"

            # Otherwise = drawer name.
            else
                resolved="$DRAWER_DIR/$target"

                if [ ! -d "$resolved" ] ||
                   [[ "$(basename "$resolved")" != drawer-* ]]; then
                    echo "Drawer not found: $target"
                    return 1
                fi
            fi

            echo "Restoring:"
            echo "  $(basename "$resolved")"
            echo

            shopt -s dotglob nullglob
            mv "$resolved"/* "$HOME/Desktop/" 2>/dev/null
            shopt -u dotglob nullglob

            echo "Restored drawer contents to ~/Desktop"
            ;;


        # ----------------------------------------------------------------------
        # REMOVE
        # ----------------------------------------------------------------------
        remove|rm)
            if [ -z "$target" ]; then
                echo "Usage: drawer remove <index|drawer-name>"
                return 1
            fi

            mapfile -t drawers < <(
                find "$DRAWER_DIR" \
                    -maxdepth 1 \
                    -mindepth 1 \
                    -type d \
                    -name "drawer-*" \
                    -print 2>/dev/null |
                    sort -r
            )

            total="${#drawers[@]}"

            if [ "$total" -eq 0 ]; then
                echo "No drawers found."
                return 1
            fi

            if [[ "$target" =~ ^[0-9]+$ ]]; then
                index=$((target - 1))

                if [ "$index" -lt 0 ] || [ "$index" -ge "$total" ]; then
                    echo "Invalid drawer index: $target"
                    return 1
                fi

                resolved="${drawers[$index]}"

            else
                resolved="$DRAWER_DIR/$target"

                if [ ! -d "$resolved" ] ||
                   [[ "$(basename "$resolved")" != drawer-* ]]; then
                    echo "Drawer not found: $target"
                    return 1
                fi
            fi

            echo "Remove drawer:"
            echo "  $(basename "$resolved")"
            echo
            echo "Contents:"

            shopt -s nullglob dotglob
            count=0

            for item in "$resolved"/*; do
                count=$((count + 1))
                printf '  %s\n' "$(basename "$item")"
            done

            shopt -u nullglob dotglob

            if [ "$count" -eq 0 ]; then
                echo "  (empty)"
            fi

            echo
            read -r -p "Permanently remove this drawer? [y/N] " answer

            case "$answer" in
                y|Y|yes|YES)
                    rm -rf -- "$resolved"

                    # If "drawer" points at the drawer we just removed,
                    # repoint it to the new latest drawer.
                    if [ -L "$DRAWER_DIR/drawer" ]; then
                        local link_target
                        link_target=$(readlink -f "$DRAWER_DIR/drawer" 2>/dev/null)

                        if [ "$link_target" = "$(readlink -f "$resolved" 2>/dev/null)" ]; then
                            rm -f "$DRAWER_DIR/drawer"

                            mapfile -t drawers < <(
                                find "$DRAWER_DIR" \
                                    -maxdepth 1 \
                                    -mindepth 1 \
                                    -type d \
                                    -name "drawer-*" \
                                    -print 2>/dev/null |
                                    sort -r
                            )

                            if [ "${#drawers[@]}" -gt 0 ]; then
                                ln -sfn "${drawers[0]}" "$DRAWER_DIR/drawer"
                            fi
                        fi
                    fi

                    echo "Removed drawer."
                    ;;

                *)
                    echo "Cancelled."
                    ;;
            esac
            ;;


        # ----------------------------------------------------------------------
        # CLEAN
        # ----------------------------------------------------------------------
        clean|c)
            mapfile -t drawers < <(
                find "$DRAWER_DIR" \
                    -maxdepth 1 \
                    -mindepth 1 \
                    -type d \
                    -name "drawer-*" \
                    -print 2>/dev/null |
                    sort -r
            )

            total="${#drawers[@]}"

            if [ "$total" -eq 0 ]; then
                echo "No drawers found."
                return
            fi

            echo "The following drawers will be removed:"
            echo

            for drawer in "${drawers[@]}"; do
                echo "  $(basename "$drawer")"
            done

            echo
            read -r -p "Remove ALL drawers permanently? [y/N] " answer

            case "$answer" in
                y|Y|yes|YES)
                    for drawer in "${drawers[@]}"; do
                        rm -rf -- "$drawer"
                    done

                    rm -f "$DRAWER_DIR/drawer"

                    echo "All drawers removed."
                    ;;

                *)
                    echo "Cancelled."
                    ;;
            esac
            ;;


        # ----------------------------------------------------------------------
        # TIDY
        # ----------------------------------------------------------------------
        tidy|t)
            mapfile -t drawers < <(
                find "$DRAWER_DIR" \
                    -maxdepth 1 \
                    -mindepth 1 \
                    -type d \
                    -name "drawer-*" \
                    -print 2>/dev/null |
                    sort -r
            )

            total="${#drawers[@]}"

            if [ "$total" -eq 0 ]; then
                echo "No drawers found."
                return
            fi

            count=0

            for drawer in "${drawers[@]}"; do
                count=$((count + 1))

                echo
                echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
                echo "Drawer $count/$total"
                echo "$(basename "$drawer")"
                echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
                echo
                echo "Contents:"

                shopt -s nullglob dotglob
                local content_count=0

                for item in "$drawer"/*; do
                    content_count=$((content_count + 1))
                    printf '  %s\n' "$(basename "$item")"
                done

                shopt -u nullglob dotglob

                if [ "$content_count" -eq 0 ]; then
                    echo "  (empty)"
                fi

                echo

                while true; do
                    echo "  [o] Open"
                    echo "  [s] Skip"
                    echo "  [r] Remove"
                    echo "  [q] Quit"
                    echo

                    read -r -p "> " choice

                    case "$choice" in
                        o|O|open)
                            cd "$drawer" || return 1
                            echo
                            echo "Opened $(basename "$drawer")"
                            echo
                            ;;

                        s|S|skip|"")
                            break
                            ;;

                        r|R|remove)
                            echo
                            read -r -p "Permanently remove this drawer? [y/N] " answer

                            case "$answer" in
                                y|Y|yes|YES)
                                    rm -rf -- "$drawer" \
                                    && echo "Removed $(basename "$drawer")."    \
                                    || echo "Error removing $(basename "$drawer")." 
                                    break
                                    ;;

                                *)
                                    echo "Not removed."
                                    ;;
                            esac
                            ;;

                        q|Q|quit)
                            echo
                            echo "Tidy stopped."
                            return
                            ;;

                        *)
                            echo "Please choose Open, Skip, Remove, or Quit."
                            ;;
                    esac
                done
            done

            echo
            echo "Tidy complete."
            ;;


        # ----------------------------------------------------------------------
        # DESKTOP
        # ----------------------------------------------------------------------
        desktop|d)
            cd "$HOME/Desktop" || return 1
            ;;


        # ----------------------------------------------------------------------
        # HELP
        # ----------------------------------------------------------------------
        h|help|"")
            cat <<EOF
Usage:
  drawer shove             Move desktop contents into a new drawer
  drawer open [id|name]    Open a drawer (latest if omitted)
  drawer list              List drawers with indexes
  drawer restore [id|name] Restore a drawer (latest if omitted)
  drawer remove <id|name>  Permanently remove a drawer
  drawer clean             Remove all drawers
  drawer tidy              Review drawers one by one
  drawer desktop           Go to the desktop
  drawer help              Show this message

Drawer selection:
  drawer open              Open latest drawer
  drawer open 1            Open drawer #1
  drawer open 3            Open drawer #3
  drawer open drawer-...   Open drawer by name

Environment:
  DRAWER_DIR               Storage location (default: ~/.drawer)
EOF
            ;;


        # ----------------------------------------------------------------------
        # UNKNOWN
        # ----------------------------------------------------------------------
        *)
            echo "Unknown command: $command"
            echo
            echo "Run 'drawer help' for usage."
            return 1
            ;;
    esac
}


export -f drawer
alias "d=drawer"
