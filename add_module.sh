#!/usr/bin/env bash

read -p "[:] Enter a name for the module: " name

read -p "[:] Enter a target for the module: " target

read -p "[:] Enter list of ignored files: " -a ignored_files
read -p "[:] Enter list of dependencies: " -a dependencies

mkdir $name

echo "$target" > "./$name/.target"
echo "0" > "./$name/.dep_count"

touch "./$name/.stow-local-ignore"
echo "[+] Adding ignored files"
for f in "${ignored_files[@]}"; do
    echo "$f" >> "./$name/.stow-local-ignore"
done

touch "./$name/.dependencies"
echo "[+] Adding dependencies"
for f in "${dependencies[@]}"; do
    echo "$f" >> "./$name/.dependencies"
done

echo "[=] Module successfully created"
