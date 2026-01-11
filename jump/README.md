# Jump
`jump` is a bash script that lets you give aliases to directories 

## The magic 
To work it uses sourcing and the `cd` command to change your current directory. 
Which is why `jump` is an alias to `source jump.sh`. 
And the aliases are in fact symlinks in the `$JUMP_DIR` directory (normally ~/.cd) with the name of the alias that point to the 
alised directory.

## Requirements
Either use my dotfiles manager which will handle the dependencies or manually add the necesary alias and directory 
described in the previous section

