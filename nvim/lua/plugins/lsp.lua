return {
  -- LazyVim overrides.
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = function(_, opts)
      local lsp = require("lspconfig")
      local configs = require("lspconfig.configs")

      if not configs.just_lsp then
        configs.just_lsp = {
          default_config = {
            cmd = { "/Users/maddeo/.cargo/bin/just-lsp" },
            filetypes = { "just" },
            root_dir = function(fname)
              return lsp.util.find_git_ancestor(fname)
            end,
            settings = {},
          },
        }
      end

      lsp.just_lsp.setup({})

      table.insert(opts.servers.tailwindcss.filetypes_include, "jinja")
    end,
  },
  -- Custom additions.
}
