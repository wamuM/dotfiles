DOTFILES_GIT_REPO="$HOME/.dotfiles/"
alias dotfiles="git --git-dir=$DOTFILES_GIT_REPO --work-tree=$HOME"
unset DOTFILES_GIT_REPO
