#===============================================
# .bashrc.d.sh
#===============================================
# This file sources all the files in ~/.bashrc.d

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"


# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
	for rc in ~/.bashrc.d/*; do
		if [ -f "$rc" ]; then
			. "$rc"
		fi
	done
fi

unset rc
# Anything bellow this line has been rudely added by the classic echo >>.bashrc
