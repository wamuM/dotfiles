if [ ! -d $HOME/.ssh/ ]; then 
	mkdir "$HOME/.ssh/"
fi
if [ ! -f $HOME/.ssh/config ]; then
	ln "$HOME/.config/ssh/config" "$HOME/.ssh/config"
fi
