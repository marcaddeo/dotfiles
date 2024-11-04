return {
  -- LazyVim overrides.
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        tailwindcss = {
          filetypes_include = { "jinja" },
        },
      },
    },
  },
  -- Custom additions.
}
