# =================================
# .bashrc.d/dotfiles.sh
# =================================
# The commands to use the dotfiles git repo

DOTFILES_GIT_REPO="$HOME/.dotfiles/"

alias dotfiles="git --git-dir=$DOTFILES_GIT_REPO --work-tree=$HOME"
