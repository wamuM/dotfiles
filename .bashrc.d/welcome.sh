# ===============================
# .bashrc.d/welcome.sh
# ===============================
# What loads when the user starts a shell

if type tmux >/dev/null 2>/dev/null; then
	if [ -z "$TMUX" ]; then
		clear
		fastfetch
	fi
else 
	clear
	fastfetch
fi
