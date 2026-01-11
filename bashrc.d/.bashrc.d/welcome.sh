# ===============================
# .bashrc.d/welcome.sh
# ===============================
# What loads when the user starts a shell

if type tmux >/dev/null 2>/dev/null; then
	if [ -z "$TMUX" ]; then
        $HOME/.bashrc.d/scripts/welcome.sh
	fi
else 
    $HOME/.bashrc.d/scripts/welcome.sh
fi
