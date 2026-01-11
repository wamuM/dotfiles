GREEN=$'\033[0;32m'
RED=$'\033[0;31m'
RESET=$'\033[0m'

"$@" \
    > >(sed "s/^/${GREEN}[out]${RESET} /" >&1) \
    2> >(sed "s/^/${RED}[err]${RESET} /" >&2)
