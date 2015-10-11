#!/bin/bash
DOTFILES="$HOME/dotfiles"

# Zsh
ln -sf $DOTFILES/.oh-my-zsh $HOME/.oh-my-zsh
ln -sf $DOTFILES/.zshrc $HOME/.zshrc

# Git
ln -sf $DOTFILES/.gitconfig $HOME/.gitconfig
ln -sf $DOTFILES/.gitignore_global $HOME/.gitignore
