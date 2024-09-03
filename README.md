# Bootstrapping

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install just
git clone --recurse-submodules -j8 https://github.com/marcaddeo/dotfiles.git ~/dotfiles
just --justfile ~/dotfiles/just/justfile dotfiles bootstrap
```
