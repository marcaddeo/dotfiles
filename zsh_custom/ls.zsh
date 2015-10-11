# Customizations to ls

# Load our custom colors for ls
eval `gdircolors $HOME/dotfiles/dircolors.256dark`

# Alias ls to the gnu ls
alias ls="gls --color=auto"
