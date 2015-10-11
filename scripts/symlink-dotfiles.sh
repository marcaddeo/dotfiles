#!/bin/bash
DOTFILES="$HOME/dotfiles"

# Zsh
ln -sf $DOTFILES/.oh-my-zsh $HOME
ln -sf $DOTFILES/.zshrc $HOME

# Git
ln -sf $DOTFILES/.gitconfig $HOME
ln -sf $DOTFILES/.gitignore_global $HOME

# Fonts
ln -sf $DOTFILES/fonts/InconsolataForPowerlinePlusNerdFileTypesMonoPlusFontAwesomePlusOcticonsPlusPomicons.otf $HOME/Library/Fonts
