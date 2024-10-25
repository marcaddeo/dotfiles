return {
  -- LazyVim overrides.
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

  -- Custom additions.
}
