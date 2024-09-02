dotfiles := home_dir() / "dotfiles"
red := `tput setaf 1`
normal := `tput sgr0`
bold := `tput bold`
error := bold + red + "ERROR:" + normal
