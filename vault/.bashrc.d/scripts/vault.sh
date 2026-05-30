#!/usr/bin/env bash

ENCRYPTED="$HOME/.Vault-encrypted"
MOUNTPOINT="$HOME/Vault"

open_vault(){
    if mountpoint -q "$MOUNTPOINT"; then
        echo "[O] Already open."
        return 0
    fi
    echo "[o] Opening vault..."
    gocryptfs "$ENCRYPTED" "$MOUNTPOINT"
    if mountpoint -q "$MOUNTPOINT"; then
        echo "[O] Vault opened."
    else
        echo "[!] Failed to open vault."
        exit 1
    fi

}
close_vault(){
    if mountpoint -q "$MOUNTPOINT"; then
        echo "[x] Closing vault..."
        fusermount -u "$MOUNTPOINT" \
        && echo "[X] Vault closed." \
        || ( echo "[!] Something failed whilst closing"; exit $? )
    else 
        echo "[X] Already closed."
    fi
}
if [ ! -f "$ENCRYPTED/gocryptfs.conf" ]; then
    mkdir -p "$ENCRYPTED"
    echo "[+] Initializing new vault at '$ENCRYPTED' that will be mounted on '$MOUNTPOINT'"
    gocryptfs -init "$ENCRYPTED"
    exit $?
fi
if [ ! -d "$MOUNTPOINT" ]; then
    mkdir -p "$MOUNTPOINT"
fi

case "${1:-toggle}" in
    status)
        if mountpoint -q "$MOUNTPOINT"; then
            echo "[O] Open"
            exit 0
        else
            echo "[X] closed"
            exit 1
        fi
        ;;
    open)
        open_vault 
        ;;
    close)
        close_vault
        ;;
    toggle)
        if mountpoint -q "$MOUNTPOINT"; then
            close_vault
        else
            open_vault
        fi
        ;;
esac
