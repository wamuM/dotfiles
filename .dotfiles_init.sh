# Based on a tutorial on www.atlassian.com 
DOTFILES_URL="git@github.com:wamuM/dotfiles.git"

echo ".dotfiles" > .gitignore
git clone --bare $DOTFILES_URL $HOME/.dotfiles/

function dotfiles {
git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME" $@
}

mkdir -p "$HOME/.dotfiles_backup"

dotfiles checkout
if [ $? = 0 ];then
	echo "Successfully changed dotfiles";
else 
	read -p "Press Enter to continue and delete problematic files";
	dotfiles checkout 2>&1 | grep -E "\s+\." | awk {'print $1'} | xargs -I{} rm -rf {} $HOME/.dotfiles_backup/{}
fi;
dotfiles checkout
dotfiles config status.showUntrackedFiles no
dotfiles remote add github git@github.com:wamuM/dotfiles.git
