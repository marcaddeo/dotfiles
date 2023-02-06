return {
  {
    "nvim-tree/nvim-tree.lua",
    config = function()
      require("nvim-tree").setup()

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
      require("todo-comments").setup({
        highlight = {
          pattern = [[.*[@\\]{1}<(KEYWORDS)\s*|.*<(KEYWORDS)\s*:]],
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
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-fzf-native.nvim",
    },
    config = function()
      local telescope = require("telescope")

      telescope.setup({})
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
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/popup.nvim",
      "nvim-lua/plenary.nvim",
    },
    config = true,
  },
}
