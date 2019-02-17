#!/bin/bash
cp ~/.bashrc .
cp ~/.gitconfig .

git add .gitconfig .bashrc
git commit -m "updated profiles"
git push
