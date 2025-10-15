# ==============================
# 	.basrc.d/alias.sh
# ==============================
# List of user defined aliases

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

## emacs
alias emacs='echo Did you mean vim?'

## Power
alias poweroff="systemctl poweroff"
alias reboot="systemctl reboot"
alias suspend="systemctl suspend"
