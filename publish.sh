#!/usr/bin/env bash
set -e

# Remember to add the origin
git subtree push --prefix=nvim/.config/nvim nvim main
git subtree push --prefix=tmux/tmux tmux main
git subtree push --prefix=awesome/awesome awesome main
