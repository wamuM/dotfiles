#!/bin/sh bash
# ==============================
# 	.basrc.d/cd.sh.d/gei.sh
# ==============================
# cd alias for ~/Documents/GEI

cd "$HOME/Documents/GEI" 

if [ $# -eq 1 ]; then
	cd $(echo "$1" | tr "[:lower:]" "[:upper:]") 
fi

if [ $# -gt 1 ]; then
	echo "[-] Too many arguments"
fi

