# ==============================
# 	.basrc.d/alias.sh
# ==============================
# List of user defined aliases

SCRIPTS_DIR="~/.bashrc.d/scripts/"

## refresh
alias refresh='source $HOME/.bashrc && echo .bashrc sourced correctly!'


## ls 
alias ls='ls --color=auto'
alias l='ls -l -a'
alias la='ls -A'

## VIm NeoVIm
alias vim='nvim'
alias vi='nvim'

## Clear and Cls
alias cls='clear && fastfetch'
alias fetch='fastfetch'

## Rename window
alias title="$SCRIPTS_DIR/title.sh"
## emacs
alias emacs='echo Did you mean vim?'

## Edit .bashrc.d
alias shconf="$EDITOR ~/.bashrc.d/"

## Power
alias poweroff="systemctl poweroff"
alias reboot="systemctl reboot"
alias suspend="systemctl suspend"

## To see stdout and stderr clearly
alias std="$SCRIPTS_DIR/std.sh"

alias open="xdg-open"
alias o="open"

## Fuzzy Finder
alias f="fzf"

## [GLArena - for GEI/G]
alias glarena="~/Documents/GEI/G/arena/GLarena"
alias glarenasl="~/Documents/GEI/G/arena/GLarenaSL"
alias glarenapl="~/Documents/GEI/G/arena/GLarenaPL"
