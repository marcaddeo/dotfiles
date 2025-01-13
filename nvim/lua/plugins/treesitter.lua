return {
  -- LazyVim overrides.
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "awk",
        "comment",
        "css",
        "dockerfile",
        "git_rebase",
        "gitattributes",
        "gitcommit",
        "gitignore",
        "go",
        "jq",
        "just",
        "make",
        "php",
        "phpdoc",
        "proto",
        "rust",
        "sql",
        "svelte",
        "twig",
      },
      indent = {
        enable = true,
        disable = {
          "markdown",
        },
      },
    },
  },

  -- Custom additions.
}
