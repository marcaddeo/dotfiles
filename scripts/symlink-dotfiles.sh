#!/bin/bash
DOTFILES="$HOME/dotfiles"

# Zsh
ln -s $DOTFILES/.oh-my-zsh $HOME/.oh-my-zsh
ln -s $DOTFILES/.zshrc $HOME/.zshrc

# Git
ln -s $DOTFILES/.gitconfig $HOME/.gitconfig
ln -s $DOTFILES/.gitignore_global $HOME/.gitignore
