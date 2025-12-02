# ==============================
# 	.basrc.d/cd.sh
# ==============================
# List of user cd aliases

CD_SH_D="$HOME/.bashrc.d/cd.sh.d/"

## GEI
export $D_GEI="$HOME/Documents/GEI"
alias gei="source $CD_SH_D/gei.sh"

### Git
alias cdgit="source $CD_SH_D/cdgit.sh"

unset CD_SH_D
