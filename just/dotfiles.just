import 'common.just'

# Display this list of available commands
@list:
    just --justfile "{{ source_file() }}" --list --unsorted

# Symlink all dotfiles into place
[confirm("This will symlink all dotfiles into place, overwriting existing files. Are you sure? [y/N]")]
link: \
    (_just "true") \
    (_zsh "true") \
    (_tmux "true") \
    (_git "true") \
    (_nvim "true") \
    (_ranger "true") \

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

@_link source destination force="false":
    mkdir -p "$(dirname "{{ home_dir() / destination }}")"
    -echo ln {{ if force == "true" { "-sf" } else { "-s" } }} \
        "{{ dotfiles / source }}" \
        "{{ home_dir() / destination }}" \
        2>/dev/null
