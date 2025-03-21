return {
  -- LazyVim overrides.

  -- Prefix keywords with @, add custom keywords, allow uppercase or lowercase
  -- keywords
  {
    "folke/todo-comments.nvim",
    config = function()
      local keywords = {
        FIX = {
          icon = " ",
          color = "error",
          alt = { "FIXME", "BUG", "FIXIT", "ISSUE" },
        },
        TODO = { icon = " ", color = "info" },
        HACK = { icon = " ", color = "warning" },
        WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
        PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
        NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
        TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
        SEE = {
          icon = "",
          color = "info",
        },
      }

      -- Add lowercase versions of each keyword, and alt keywords.
      for key, val in pairs(keywords) do
        keywords[key:lower()] = val
        if val.alt ~= nil then
          local aliases = {}
          for _, alias in pairs(val.alt) do
            table.insert(aliases, alias:lower())
          end
          keywords[key:lower()].alt = vim.tbl_deep_extend("force", val.alt, aliases)
        end
      end

      require("todo-comments").setup({
        keywords = keywords,
        highlight = {
          pattern = [[.*[@]{1}<(KEYWORDS):?\s*]],
          keyword = "bg",
        },
        search = {
          pattern = [[[@]{1}\b(KEYWORDS)(\s|:)]],
        },
      })
    end,
  },

  -- Set preset back to modern instead of the new helix default.
  {
    "folke/which-key.nvim",
    opts = {
      preset = "modern",
    },
  },

  -- Configure flash.nvim to use default FfTt behavior.
  {
    "folke/flash.nvim",
    opts = {
      modes = {
        char = {
          char_actions = function()
            return { [";"] = "next", [","] = "prev" }
          end,
        },
      },
    },
  },

  -- Custom additions.
  {
    "aserowy/tmux.nvim",
    config = true,
    event = "BufReadPre",
    opt = {
      copy_sync = {
        enable = false,
      },
    },
  },
  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup(nil, {
        names = false,
      })
    end,
  },

  -- @note using a patched version to fix duplicate icons.
  -- @see https://github.com/topaxi/gh-actions.nvim/pull/13
  {
    "marcaddeo/gh-actions.nvim",
    branch = "patch-1",
    keys = {
      { "<leader>ga", "<cmd>GhActions<cr>", desc = "Open Github Actions" },
    },
    ---@type GhActionsConfig
    opts = {},
  },
}
