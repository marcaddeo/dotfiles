return {
  {
    "nvim-tree/nvim-tree.lua",
    config = function()
      local function on_attach(bufnr)
        local api = require('nvim-tree.api')

        local function opts(desc)
          return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end

        -- BEGIN_DEFAULT_ON_ATTACH
        vim.keymap.set('n', '<C-]>', api.tree.change_root_to_node,          opts('CD'))
        vim.keymap.set('n', '<C-e>', api.node.open.replace_tree_buffer,     opts('Open: In Place'))
        vim.keymap.set('n', '<C-k>', api.node.show_info_popup,              opts('Info'))
        vim.keymap.set('n', '<C-r>', api.fs.rename_sub,                     opts('Rename: Omit Filename'))
        vim.keymap.set('n', '<C-t>', api.node.open.tab,                     opts('Open: New Tab'))
        vim.keymap.set('n', '<C-v>', api.node.open.vertical,                opts('Open: Vertical Split'))
        vim.keymap.set('n', '<C-x>', api.node.open.horizontal,              opts('Open: Horizontal Split'))
        vim.keymap.set('n', '<BS>',  api.node.navigate.parent_close,        opts('Close Directory'))
        vim.keymap.set('n', '<CR>',  api.node.open.edit,                    opts('Open'))
        vim.keymap.set('n', '<Tab>', api.node.open.preview,                 opts('Open Preview'))
        vim.keymap.set('n', '>',     api.node.navigate.sibling.next,        opts('Next Sibling'))
        vim.keymap.set('n', '<',     api.node.navigate.sibling.prev,        opts('Previous Sibling'))
        vim.keymap.set('n', '.',     api.node.run.cmd,                      opts('Run Command'))
        vim.keymap.set('n', '-',     api.tree.change_root_to_parent,        opts('Up'))
        vim.keymap.set('n', 'a',     api.fs.create,                         opts('Create'))
        vim.keymap.set('n', 'bmv',   api.marks.bulk.move,                   opts('Move Bookmarked'))
        vim.keymap.set('n', 'B',     api.tree.toggle_no_buffer_filter,      opts('Toggle No Buffer'))
        vim.keymap.set('n', 'c',     api.fs.copy.node,                      opts('Copy'))
        vim.keymap.set('n', 'C',     api.tree.toggle_git_clean_filter,      opts('Toggle Git Clean'))
        vim.keymap.set('n', '[c',    api.node.navigate.git.prev,            opts('Prev Git'))
        vim.keymap.set('n', ']c',    api.node.navigate.git.next,            opts('Next Git'))
        vim.keymap.set('n', 'd',     api.fs.remove,                         opts('Delete'))
        vim.keymap.set('n', 'D',     api.fs.trash,                          opts('Trash'))
        vim.keymap.set('n', 'E',     api.tree.expand_all,                   opts('Expand All'))
        vim.keymap.set('n', 'e',     api.fs.rename_basename,                opts('Rename: Basename'))
        vim.keymap.set('n', ']e',    api.node.navigate.diagnostics.next,    opts('Next Diagnostic'))
        vim.keymap.set('n', '[e',    api.node.navigate.diagnostics.prev,    opts('Prev Diagnostic'))
        vim.keymap.set('n', 'F',     api.live_filter.clear,                 opts('Clean Filter'))
        vim.keymap.set('n', 'f',     api.live_filter.start,                 opts('Filter'))
        vim.keymap.set('n', 'g?',    api.tree.toggle_help,                  opts('Help'))
        vim.keymap.set('n', 'gy',    api.fs.copy.absolute_path,             opts('Copy Absolute Path'))
        vim.keymap.set('n', 'H',     api.tree.toggle_hidden_filter,         opts('Toggle Dotfiles'))
        vim.keymap.set('n', 'I',     api.tree.toggle_gitignore_filter,      opts('Toggle Git Ignore'))
        vim.keymap.set('n', 'J',     api.node.navigate.sibling.last,        opts('Last Sibling'))
        vim.keymap.set('n', 'K',     api.node.navigate.sibling.first,       opts('First Sibling'))
        vim.keymap.set('n', 'm',     api.marks.toggle,                      opts('Toggle Bookmark'))
        vim.keymap.set('n', 'o',     api.node.open.edit,                    opts('Open'))
        vim.keymap.set('n', 'O',     api.node.open.no_window_picker,        opts('Open: No Window Picker'))
        vim.keymap.set('n', 'p',     api.fs.paste,                          opts('Paste'))
        vim.keymap.set('n', 'P',     api.node.navigate.parent,              opts('Parent Directory'))
        vim.keymap.set('n', 'q',     api.tree.close,                        opts('Close'))
        vim.keymap.set('n', 'r',     api.fs.rename,                         opts('Rename'))
        vim.keymap.set('n', 'R',     api.tree.reload,                       opts('Refresh'))
        vim.keymap.set('n', 's',     api.node.run.system,                   opts('Run System'))
        vim.keymap.set('n', 'S',     api.tree.search_node,                  opts('Search'))
        vim.keymap.set('n', 'U',     api.tree.toggle_custom_filter,         opts('Toggle Hidden'))
        vim.keymap.set('n', 'W',     api.tree.collapse_all,                 opts('Collapse'))
        vim.keymap.set('n', 'x',     api.fs.cut,                            opts('Cut'))
        vim.keymap.set('n', 'y',     api.fs.copy.filename,                  opts('Copy Name'))
        vim.keymap.set('n', 'Y',     api.fs.copy.relative_path,             opts('Copy Relative Path'))
        vim.keymap.set('n', '<2-LeftMouse>',  api.node.open.edit,           opts('Open'))
        vim.keymap.set('n', '<2-RightMouse>', api.tree.change_root_to_node, opts('CD'))
        -- END_DEFAULT_ON_ATTACH

        vim.keymap.set('n', 'z', function()
          local node = api.tree.get_node_under_cursor()
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
        end, opts('Copy file to'))
      end

      require("nvim-tree").setup({
        on_attach = on_attach,
        actions = {
          open_file = {
            resize_window = false,
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
