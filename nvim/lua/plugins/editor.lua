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

  {
    "topaxi/pipeline.nvim",
    keys = {
      { "<leader>ci", "<cmd>Pipeline<cr>", desc = "Open pipeline.nvim" },
    },
    ---@type pipeline.Config
    opts = {},
  },

  {
    "nvim-tree/nvim-tree.lua",
    config = true,
    opts = {
      on_attach = function(bufnr)
        local api = require("nvim-tree.api")

        local function opts(desc)
          return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end

        api.config.mappings.default_on_attach(bufnr)

        local function copy_file_to()
          local node = api.tree.get_node_under_cursor()
          local file_src = node["absolute_path"]
          -- The args of input are {prompt}, {default}, {completion}
          -- Read in the new file path using the existing file's path as the baseline.
          local file_out = vim.fn.input("COPY TO: ", file_src, "file")
          -- Create any parent dirs as required
          local dir = vim.fn.fnamemodify(file_out, ":h")
          vim.fn.system({ "mkdir", "-p", dir })
          -- Copy the file
          vim.fn.system({ "cp", "-R", file_src, file_out })
        end

        vim.keymap.set("n", "z", copy_file_to, opts("Copy File To"))
        vim.keymap.set("n", "?", api.tree.toggle_help, opts("Help"))

        -- Make :bd and :q behave as usual when tree is visible
        vim.api.nvim_create_autocmd({ "BufEnter", "QuitPre" }, {
          nested = false,
          callback = function(e)
            local tree = require("nvim-tree.api").tree

            -- Nothing to do if tree is not opened
            if not tree.is_visible() then
              return
            end

            -- How many focusable windows do we have? (excluding e.g. incline status window)
            local winCount = 0
            for _, winId in ipairs(vim.api.nvim_list_wins()) do
              if vim.api.nvim_win_get_config(winId).focusable then
                winCount = winCount + 1
              end
            end

            -- We want to quit and only one window besides tree is left
            if e.event == "QuitPre" and winCount == 2 then
              vim.api.nvim_cmd({ cmd = "qall" }, {})
            end

            -- :bd was probably issued an only tree window is left
            -- Behave as if tree was closed (see `:h :bd`)
            if e.event == "BufEnter" and winCount == 1 then
              -- Required to avoid "Vim:E444: Cannot close last window"
              vim.defer_fn(function()
                -- close nvim-tree: will go to the last buffer used before closing
                tree.toggle({ find_file = true, focus = true })
                -- re-open nivm-tree
                tree.toggle({ find_file = true, focus = false })
              end, 10)
            end
          end,
        })
      end,
      view = {
        signcolumn = "no",
      },
      renderer = {
        highlight_git = "name",
        icons = {
          git_placement = "right_align",
        },
      },
    },
    keys = {
      { "<leader>e", "<cmd>NvimTreeFindFileToggle<cr>", { desc = "Open File Exporer at current file", silent = true } },
    },
  },

  {
    "tpope/vim-fugitive",
    config = function()
      -- Close fugitive windows with q instead of gq
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "fugitiveblame", "fugitive" },
        callback = function()
          vim.api.nvim_buf_set_keymap(0, "n", "q", "gq", { silent = true })
        end,
      })
    end,
  },
}
