# 	Neofetch Configuration 

# Don't show neofetch when opening shell on tmux
if type tmux >/dev/null 2>/dev/null; then
	if [ -z "$TMUX" ]; then
		clear
		neofetch --ascii_distro qubes-os
	fi
else 
	clear
	neofetch --ascii_distro qubes-os
fi 
