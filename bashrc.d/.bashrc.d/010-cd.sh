# ==============================
# 	.basrc.d/cd.sh
# ==============================
# List of user cd aliases

CD_SH_D="$HOME/.bashrc.d/scripts/"

## GEI
export D_GEI="$HOME/Documents/GEI"
alias gei="source $CD_SH_D/gei.sh"

### Git
alias cdgit="source $CD_SH_D/cdgit.sh"

## Real CD
alias rcd="source $CD_SH_D/rcd.sh"
unset CD_SH_D
