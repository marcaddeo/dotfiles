return {
  {
    "nvim-tree/nvim-tree.lua",
    config = function()
      local function copy_file_to(node)
        local file_src = node['absolute_path']
        -- The args of input are {prompt}, {default}, {completion}
        -- Read in the new file path using the existing file's path as the baseline.
        local file_out = vim.fn.input("COPY TO: ", file_src, "file")

        if file_out == nil or file_out == "" then
          return
        end

        -- Create any parent dirs as required
        local dir = vim.fn.fnamemodify(file_out, ":h")
        vim.fn.system { 'mkdir', '-p', dir }
        -- Copy the file
        vim.fn.system { 'cp', '-R', file_src, file_out }
      end

      require("nvim-tree").setup({
        actions = {
          open_file = {
            resize_window = false,
          },
        },
        view = {
          mappings = {
            list = {
              { key = "z", action = "Copy file to", action_cb = copy_file_to },
            },
          },
        },
      })

      local function open_nvim_tree(data)
        -- buffer is a real file on the disk
        local real_file = vim.fn.filereadable(data.file) == 1

        -- buffer is a [No Name]
        local no_name = data.file == "" and vim.bo[data.buf].buftype == ""

        if not real_file and not no_name then
          return
        end

        local disabled_filetypes = {
          "gitcommit",
        }

        for _, disabled_type in ipairs(disabled_filetypes) do
          if vim.bo[data.buf].filetype == disabled_type then
            return
          end
        end

        -- open the tree, find the file but don't focus it
        require("nvim-tree.api").tree.toggle({ focus = false, find_file = true, })
      end

      vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })
    end,
  },

  {
    "lewis6991/gitsigns.nvim",
    config = true,
  },

  {
    "folke/todo-comments.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      -- Default keywords
      -- @see https://github.com/folke/todo-comments.nvim/blob/main/lua/todo-comments/config.lua
      local default_keywords = {
        FIX = {
          icon = " ", -- icon used for the sign, and in search results
          color = "error", -- can be a hex color, or a named color (see below)
          alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
          -- signs = false, -- configure signs for some keywords individually
        },
        TODO = { icon = " ", color = "info" },
        HACK = { icon = " ", color = "warning" },
        WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
        PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
        NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
        TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
      }

      -- Custom keywords
      local keywords = {
        SEE = {
          icon = "",
          color = "info",
        },
      }

      keywords = vim.tbl_deep_extend("force", {}, default_keywords, keywords)
      -- Add lowercase versions of each keyword
      for key, val in pairs(keywords) do
        keywords[key:lower()] = val
      end

      require("todo-comments").setup({
        keywords = keywords,
        highlight = {
          pattern = [[.*[@\\]{1}<(KEYWORDS)\s*|.*<(KEYWORDS)\s*:]],
          keyword = "bg",
        },
        search = {
          pattern = [[[\\\\@]*\b(KEYWORDS)(\s|:)]],
        }
      })
    end,
  },

  {
    "NvChad/nvim-colorizer.lua",
    config = true,
  },

  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
    lazy = false,
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-fzf-native.nvim",
    },
    config = function()
      local telescope = require("telescope")

      telescope.setup({
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
        },
        defaults = {
          file_ignore_patterns = {
            ".git/COMMIT_EDITMSG",
          },
        },
        pickers = {
          find_files = {
            no_ignore = true,
          },
        },
      })
      telescope.load_extension("fzf")
      telescope.load_extension("notify")
      telescope.load_extension("noice")
    end,
  },

  {"folke/trouble.nvim", config = true},

  "gpanders/editorconfig.nvim",
  "jghauser/mkdir.nvim",
  "tpope/vim-fugitive",
  "tpope/vim-rhubarb",
  "tpope/vim-sleuth",
  "tpope/vim-abolish",
  "godlygeek/tabular",
  {
    "numtostr/BufOnly.nvim",
    cmd = "BufOnly",
  },
  {
    "aserowy/tmux.nvim",
    config = true,
  },
  {
    "windwp/nvim-autopairs",
    config = true,
  },
  {
    "ethanholz/nvim-lastplace",
    config = true,
  },
  {
    "sudormrfbin/cheatsheet.nvim",
    enabled = false,
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/popup.nvim",
      "nvim-lua/plenary.nvim",
    },
    config = true,
  },

  {
    "folke/which-key.nvim",
    config = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300

      require("which-key").setup({
        plugins = {
          spelling = { enabled = true },
        },
      })
    end
  },
}
