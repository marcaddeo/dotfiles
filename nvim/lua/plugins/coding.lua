return {
  -- LazyVim overrides.

  -- Configure LuaSnip to laod custom vscode-style snippets.
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "rafamadriz/friendly-snippets",
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
        require("luasnip.loaders.from_vscode").lazy_load({
          paths = vim.fn.stdpath("config") .. "/snippets/",
        })
      end,
    },
  },

  -- Custom additions.
}
