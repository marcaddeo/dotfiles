ulimit -n 10000
# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="my"

# Uncomment the following line to use case-sensitive completion.
CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
HIST_STAMPS="yyyy-mm-dd"

# Automatically start tmux
ZSH_TMUX_AUTOSTART=false
# Don't automatically quit when detaching
ZSH_TMUX_AUTOQUIT=false

# Would you like to use another custom folder than $ZSH/custom?
ZSH_CUSTOM=$HOME/dotfiles/zsh/custom

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git gpg-agent jira sprunge sudo tmux ssh-agent zsh-nvm)

# User configuration

export PATH="$HOME/.local/bin:$(python3 -m site --user-base)/bin:$HOME/dotfiles/bin:$HOME/.composer/vendor/bin:/usr/local/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
# export MANPATH="/usr/local/man:$MANPATH"

eval "$(/opt/homebrew/bin/brew shellenv)"

source $ZSH/oh-my-zsh.sh
source "$HOME/.console/console.rc" 2>/dev/null

# Load fzf bindings
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Load a custom terminfo file to fix backspace in neovim
[[ -f "~/.$TERM.ti" ]] && tic ~/.$TERM.ti
CARGO_ENV="$HOME/.cargo/env"
if [[ -f "$CARGO_ENV" ]]; then
	source "$CARGO_ENV"
fi

export HOMEBREW_GITHUB_TOKEN="7c5cd9ce62c06106acde6bd9187bffc3d83dcabd"

eval $(gdircolors $HOME/dotfiles/misc/dircolors.solarized.ansi-dark)

if [[ "$(command -v pyenv)" ]]; then
	eval "$(pyenv init --path)"
fi
