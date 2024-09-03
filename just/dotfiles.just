import "common.just"

brew_packages := "\
ansible \
cmake \
colordiff \
composer \
coreutils \
curl \
d2 \
diff-so-fancy \
fzf \
git \
git-filter-repo \
gnupg \
httpie \
jq \
just \
mosh \
neovim \
php \
pkg-config \
pv \
ranger \
remake \
rename \
ripgrep \
shellcheck \
sqlite \
terminus \
tig \
tmux \
tree \
wget \
yq \
zsh \
"
brew_cask_packages := "\
font-fantasque-sans-mono-nerd-font \
font-fira-code-nerd-font \
font-hasklug-nerd-font \
font-inconsolata-nerd-font \
font-symbols-only-nerd-font \
"

# Display this list of available commands
@list:
    just --justfile "{{ source_file() }}" --list --unsorted

# (UNTESTED) Bootstrap local environment with common packages and my dotfiles
@bootstrap: (_brew_install brew_packages) (_brew_cask_isntall brew_cask_packages) _install_rust
    just --justfile "{{ source_file() }}" --yes link
    cp "{{ dotfiles }}/fonts/InInconsolataForPowerlinePlusNerdFileTypesMonoPlusFontAwesomePlusOcticonsPlusPomicons.otf" "$HOME/Library/Fonts"
    source ~/.zshrc && nvm install --lts

# Open dotfiles directory in editor
@edit:
    cd "{{ dotfiles }}" && $EDITOR

# Symlink all dotfiles into place
[confirm("This will symlink all dotfiles into place, overwriting existing files. Are you sure? [y/N]")]
link: (_just "true") (_zsh "true") (_tmux "true") (_git "true") (_nvim "true") (_ranger "true") (_ssh "true")

### Helpers

_brew_install *packages:
    brew install {{ packages }}

_brew_cask_isntall *packages:
    brew install --cask {{ packages }}

_install_rust:
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -q -y

@_link source destination force="false":
    mkdir -p "$(dirname "{{ home_dir() / destination }}")"
    -echo ln {{ if force == "true" { "-sf" } else { "-s" } }} \
        "{{ dotfiles / source }}" \
        "{{ home_dir() / destination }}" \
        2>/dev/null

### Link Implementations

# Link just related files
[group("just")]
link-just force="false": (_just force)

_just force="false": (_link "just/justfile" ".justfile" force)

# Link zsh related files
[group("zsh")]
link-zsh force="false": (_zsh force)

_zsh force="false": (_zshrc force) (_oh-my-zsh force)

# Link .zshrc file
[group("zsh")]
link-zshrc force="false": (_zshrc force)

_zshrc force="false": (_link "zsh/.zshrc" ".zshrc" force)

# Link .oh-my-zsh folder
[group("zsh")]
link-oh-my-zsh force="false": (_oh-my-zsh force)

_oh-my-zsh force="false": (_link "zsh/.oh-my-zsh" ".oh-my-zsh" force)

# Link tmux related files
[group("tmux")]
link-tmux force="false": (_tmux force)

_tmux force="false": (_tmux_conf force) (_tmux_tpm force) (_tmux_resurrect force)

# Link .tmux.conf file
[group("tmux")]
link-tmux-conf force="false": (_tmux_conf force)

_tmux_conf force="false": (_link "tmux/.tmux.conf" ".tmux.conf" force)

# Link .tmux/plugins/tpm folder
[group("tmux")]
link-tmux-tpm force="false": (_tmux_tpm force)

_tmux_tpm force="false": (_link "tmux/tpm" ".tmux/plugins/tpm" force)

# Link .tmux/resurrect folder
[group("tmux")]
link-tmux-resurrect force="false": (_tmux_resurrect force)

_tmux_resurrect force="false": (_link "tmux/resurrect" ".tmux/resurrect" force)

# Link git related files
[group("git")]
link-git force="false": (_git force)

_git force="false": (_gitconfig force) (_gitignore force)

# Link .gitconfig file
[group("git")]
link-gitconfig force="false": (_gitconfig force)

_gitconfig force="false": (_link "git/.gitconfig" ".gitconfig" force)

# Link .gitignore file
[group("git")]
link-gitignore force="false": (_gitignore force)

_gitignore force="false": (_link "git/.gitignore" ".gitignore" force)

# Link nvim related files
[group("nvim")]
link-nvim force="false": (_nvim force)

_nvim force="false": (_link "nvim" ".config/nvim" force)

# Link ranger related files
[group("ranger")]
link-ranger force="false": (_ranger force)

_ranger force="false": (_link "ranger" ".config/ranger" force)

# Link SSH related files
[group("ssh")]
link-ssh force="false": (_ssh force)

_ssh force="false": (_ssh_config force)

# Link SSH config file
[group("ssh")]
link-ssh-config force="false": (_ssh_config force)

_ssh_config force="false": (_link "ssh/config" ".ssh/config" force)
