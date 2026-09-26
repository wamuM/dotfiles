#!/usr/bin/env bash

: "${DRAWER_DIR:=$HOME/.drawer}"
: "${DRAWER_META_FILE:=.drawer-meta}"


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
    local title=""
    local new_title=""
    local content_count=0


    # --------------------------------------------------------------------------
    # READ DRAWER TITLE
    # --------------------------------------------------------------------------
    drawer_read_title() {
        local path="$1"

        title="Untitled drawer"

        if [ -f "$path/$DRAWER_META_FILE" ]; then
            title=$(cat "$path/$DRAWER_META_FILE")

            [ -z "$title" ] && title="Untitled drawer"
        fi
    }


    # --------------------------------------------------------------------------
    # WRITE DRAWER TITLE
    # --------------------------------------------------------------------------
    drawer_write_title() {
        local path="$1"
        local drawer_title="$2"

        printf '%s\n' "$drawer_title" > "$path/$DRAWER_META_FILE"
    }


    # --------------------------------------------------------------------------
    # RESOLVE DRAWER
    # --------------------------------------------------------------------------
    drawer_resolve() {
        local target="$1"

        # No argument = latest.
        if [ -z "$target" ]; then
            resolved="${drawers[0]}"
            return 0
        fi

        # Numeric argument = index.
        if [[ "$target" =~ ^[0-9]+$ ]]; then
            index=$((target - 1))

            if [ "$index" -lt 0 ] || [ "$index" -ge "$total" ]; then
                echo "Invalid drawer index: $target"
                return 1
            fi

            resolved="${drawers[$index]}"
            return 0
        fi

        # Otherwise = drawer name.
        resolved="$DRAWER_DIR/$target"

        if [ ! -d "$resolved" ] ||
           [[ "$(basename "$resolved")" != drawer-* ]]; then
            echo "Drawer not found: $target"
            return 1
        fi

        return 0
    }


    case "$command" in

        # ----------------------------------------------------------------------
        # SHOVE
        # ----------------------------------------------------------------------
        shove|s)
            local stamp

            # Optional title.
            # Example:
            #   drawer shove "Client project"
            #
            # No title = Untitled drawer.
            shift 
            title="${*:-Untitled drawer}"

            mkdir -p "$DRAWER_DIR"

            stamp=$(date +"%Y-%m-%d_%H-%M-%S-%3N")
            drawer="$DRAWER_DIR/drawer-${stamp}_${RANDOM}"

            mkdir -p "$drawer"

            shopt -s dotglob nullglob
            mv "$HOME/Desktop"/* "$drawer/" 2>/dev/null
            shopt -u dotglob nullglob

            mkdir -p "$HOME/Desktop"

            drawer_write_title "$drawer" "$title"

            ln -sfn "$drawer" "$DRAWER_DIR/drawer"

            echo "Dumped all desktop contents to:"
            echo "  $drawer"
            echo
            echo "Title:"
            echo "  $title"
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

            count=0

            for drawer in "${drawers[@]}"; do
                count=$((count + 1))

                drawer_read_title "$drawer"

                if [ "$drawer" = "$latest" ]; then
                    printf '  %2d  %s  — %s (latest)\n' \
                        "$count" \
                        "$(basename "$drawer")" \
                        "$title"
                else
                    printf '  %2d  %s  — %s\n' \
                        "$count" \
                        "$(basename "$drawer")" \
                        "$title"
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

            if ! drawer_resolve "$target"; then
                return 1
            fi

            drawer_read_title "$resolved"

            cd "$resolved" || return 1
            ;;


        # ----------------------------------------------------------------------
        # EDIT
        # ----------------------------------------------------------------------
        edit|e)
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

            if ! drawer_resolve "$target"; then
                return 1
            fi

            drawer_read_title "$resolved"

            echo "Current title: $title"
            read -r -p "New title: " new_title

            if [ -z "$new_title" ]; then
                echo "Title unchanged."
                return
            fi

            drawer_write_title "$resolved" "$new_title"

            echo "Title updated:"
            echo "  $new_title"
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

            if ! drawer_resolve "$target"; then
                return 1
            fi

            drawer_read_title "$resolved"

            echo "Restoring:"
            echo "  $title"
            echo

            shopt -s dotglob nullglob

            for item in "$resolved"/*; do
                # Never restore metadata to Desktop.
                if [ "$(basename "$item")" = "$DRAWER_META_FILE" ]; then
                    continue
                fi

                mv -- "$item" "$HOME/Desktop/" 2>/dev/null
            done

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

            if ! drawer_resolve "$target"; then
                return 1
            fi

            drawer_read_title "$resolved"

            echo "Remove drawer:"
            echo "  $title"
            echo "  $(basename "$resolved")"
            echo
            echo "Contents:"

            shopt -s nullglob dotglob
            count=0

            for item in "$resolved"/*; do
                if [ "$(basename "$item")" = "$DRAWER_META_FILE" ]; then
                    continue
                fi

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
                    local old_resolved="$resolved"
                    local link_target=""

                    rm -rf -- "$resolved"

                    # If "drawer" points at the drawer we just removed,
                    # repoint it to the new latest drawer.
                    if [ -L "$DRAWER_DIR/drawer" ]; then
                        link_target=$(readlink -f "$DRAWER_DIR/drawer" 2>/dev/null)
                        old_resolved=$(readlink -f "$old_resolved" 2>/dev/null)

                        if [ "$link_target" = "$old_resolved" ]; then
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
                drawer_read_title "$drawer"
                echo "  $title"
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

                drawer_read_title "$drawer"

                echo
                echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
                echo "Drawer $count/$total"
                echo "$title"
                echo "$(basename "$drawer")"
                echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
                echo
                echo "Contents:"

                shopt -s nullglob dotglob
                content_count=0

                for item in "$drawer"/*; do
                    if [ "$(basename "$item")" = "$DRAWER_META_FILE" ]; then
                        continue
                    fi

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
                    echo "  [e] Edit name"
                    echo "  [s] Skip"
                    echo "  [r] Remove"
                    echo "  [q] Quit"
                    echo

                    read -r -p "> " choice

                    case "$choice" in
                        o|O|open)
                            cd "$drawer" || return 1
                            echo
                            echo "Opened $title"
                            echo
                            ;;

                        e|E|edit)
                            echo
                            echo "Current title: $title"

                            read -r -p "New title: " new_title

                            if [ -z "$new_title" ]; then
                                echo "Title unchanged."
                            else
                                drawer_write_title "$drawer" "$new_title"
                                title="$new_title"

                                echo "Title updated:"
                                echo "  $title"
                            fi

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
                                    && echo "Removed $title." \
                                    || echo "Error removing $title."
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
                            echo "Please choose Open, Edit name, Skip, Remove, or Quit."
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
  drawer shove [title]          Move desktop contents into a new drawer
  drawer open [id|name]         Open a drawer (latest if omitted)
  drawer list                   List drawers with indexes and titles
  drawer edit [id|name]         Edit a drawer's title
  drawer restore [id|name]      Restore a drawer (latest if omitted)
  drawer remove <id|name>       Permanently remove a drawer
  drawer clean                  Remove all drawers
  drawer tidy                   Review drawers one by one
  drawer desktop                Go to the desktop
  drawer help                   Show this message

Examples:
  drawer shove
  drawer shove "Client project"
  drawer open 1
  drawer edit 1
  drawer restore 2
  drawer remove 3

Drawer selection:
  drawer open                   Open latest drawer
  drawer open 1                 Open drawer #1
  drawer open 3                 Open drawer #3
  drawer open drawer-...        Open drawer by name

Environment:
  DRAWER_DIR                    Storage location (default: ~/.drawer)
  DRAWER_META_FILE              Metadata filename (default: .drawer-meta)
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

