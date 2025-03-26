return {
  -- LazyVim overrides.

  -- Configure LuaSnip to laod custom vscode-style snippets.
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "rafamadriz/friendly-snippets",
      config = function()
        local luasnip = require("luasnip")

        vim.api.nvim_create_autocmd("ModeChanged", {
          group = vim.api.nvim_create_augroup("UnlinkLuaSnipSnippetOnModeChange", {
            clear = true,
          }),
          pattern = { "s:n", "i:*" },
          desc = "Forget the current snippet when leaving the insert mode",
          callback = function(evt)
            -- If we have n active nodes, n - 1 will still remain after a `unlink_current()` call.
            -- We unlink all of them by wrapping the calls in a loop.
            while true do
              if luasnip.session and luasnip.session.current_nodes[evt.buf] and not luasnip.session.jump_active then
                luasnip.unlink_current()
              else
                break
              end
            end
          end,
        })

        require("luasnip.loaders.from_vscode").lazy_load()
        require("luasnip.loaders.from_vscode").lazy_load({
          paths = vim.fn.stdpath("config") .. "/snippets/",
        })
      end,
    },
  },

  -- Configure blink.cmp keybinds similar to Super Tab.
  {
    "saghen/blink.cmp",
    opts = function(_, opts)
      opts.appearance = opts.appearance or {}
      opts.appearance.kind_icons = vim.tbl_extend("force", opts.appearance.kind_icons or {}, LazyVim.config.icons.kinds)
      opts.keymap = {
        preset = "enter",
        ["<S-Tab>"] = { "select_prev", "fallback" },
        ["<Tab>"] = { "select_next", "fallback" },
      }
    end,
  },

  -- Custom additions.

  -- I prefer this to mini.surround.
  {
    "kylechui/nvim-surround",
    config = true,
  },
}
