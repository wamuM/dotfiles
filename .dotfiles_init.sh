# Based on a tutorial on www.atlassian.com 
DOTFILES_URL="https://github.com/wamuM/dotfiles.git"

echo ".dotfiles" > .gitignore
git clone --bare $DOTFILES_URL $HOME/.dotfiles/

function dotfiles{
	/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME $@
}

mkdir -p "$HOME/.dotfiles_backup"

dotfiles checkout
if [ $? = 0 ];then
	echo "Successfully changed dotfiles";
else 
	echo "Backing up pre-existing dot files into .dotfiles_backup";
	dotfiles checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} $HOME/.dotfiles_backup/{}
fi;
dotfiles checkout
dotfiles config status.show.UntrackedFiles no
dotfiles remote add github git@github.com:wamuM/dotfiles.git
