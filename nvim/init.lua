
vim.g.mapleader = " "
-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

vim.diagnostic.config({
  float = { border = "rounded" },
})

-------------------------------------------------------------------------------
-- Bootstrap lazy.nvim package manager
-------------------------------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-------------------------------------------------------------------------------
-- Plugins
-------------------------------------------------------------------------------
require("lazy").setup({
  -----------------------------------------------------------------------------
  -- Enhancement Plugins
  -----------------------------------------------------------------------------
  {
    "nvim-treesitter/nvim-treesitter",
    version = false,
    build = ":TSUpdate",
    event = "BufReadPost",
    opts = {
      autotag = {
        enable = true,
        filetypes = {
          "html",
          "javascript",
          "typescript",
          "javascriptreact",
          "typescriptreact",
          "svelte",
          "vue",
          "tsx",
          "jsx",
          "rescript",
          "xml",
          "php",
          "markdown",
          "glimmer",
          "handlebars",
          "hbs",
          "htmldjango",
          "html.twig",
          "twig"
        },
      },
      endwise = { enable = true, },
      highlight = {
        enable = true,
      },
      indent = {
        -- I had to disable this in order to get /** comments working in PHP.
        enable = true,
      },
      context_commentstring = { enable = true, enable_autocmd = false },
      ensure_installed = {
        "awk",
        "bash",
        "comment",
        "css",
        "dockerfile",
        "elixir",
        "erlang",
        "git_rebase",
        "gitattributes",
        "gitcommit",
        "gitignore",
        "go",
        "graphql",
        "help",
        "html",
        "javascript",
        "json",
        "json5",
        "jq",
        "lua",
        "make",
        "markdown",
        "markdown_inline",
        "php",
        "phpdoc",
        "python",
        "query",
        "regex",
        "ruby",
        "rust",
        "sql",
        "svelte",
        "toml",
        "tsx",
        "typescript",
        "twig",
        "vim",
        "vue",
        "yaml",
      },
    },
    dependencies = {
      "windwp/nvim-ts-autotag",
      "RRethy/nvim-treesitter-endwise",
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
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

    -- Default mappings
    -- gD = "lua vim.lsp.buf.declaration()",
    -- gd = "lua require"telescope.builtin".lsp_definitions()",
    -- gt = "lua vim.lsp.buf.type_definition()",
    -- gi = "lua require"telescope.builtin".lsp_implementations()",
    -- gr = "lua require"telescope.builtin".lsp_references()",
    -- K = "lua vim.lsp.buf.hover()",
    -- ["<C-k>"] = "lua vim.lsp.buf.signature_help()",
    -- ["<space>rn"] = "lua vim.lsp.buf.rename()",
    -- ["<space>ca"] = "lua vim.lsp.buf.code_action()",
    -- ["<space>f"] = "lua vim.lsp.buf.formatting()",
    -- ["<space>e"] = "lua vim.diagnostic.open_float()",
    -- ["[d"] = "lua vim.diagnostic.goto_prev()",
    -- ["]d"] = "lua vim.diagnostic.goto_next()",
  {
    "junnplus/lsp-setup.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "folke/neodev.nvim",
      "simrat39/rust-tools.nvim",
    },
    config = function()
      local rt = require("lsp-setup.rust-tools")

      require("neodev").setup()
      require("lsp-setup").setup({
        mappings = {
          gd = 'lua require("telescope.builtin").lsp_definitions()',
          gi = 'lua require("telescope.builtin").lsp_implementations()',
          gr = 'lua require("telescope.builtin").lsp_references()',
        },
        servers = {
          phpactor = {},
          rust_analyzer = rt.setup({
            on_attach = function(_, bufnr)
              -- Hover actions
              -- @TODO: this doesnt work
              vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
              -- Code action groups
              vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
            end,
            server = {
              settings = {
                ["rust-analyzer"] = {
                  cargo = {
                    loadOutDirsFromCheck = true,
                  },
                  procMacro = {
                    enable = true,
                  },
                },
              },
            },
          })
        },
      })
    end,
  },

  {
    "L3MON4D3/LuaSnip",
    version = "<CurrentMajor>.*",
    build = "make install_jsregexp",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    config = function()
      local luasnip = require("luasnip")

      luasnip.filetype_extend("twig", {"twig"})

      -- @TODO: custom snippets arent working
      require("luasnip.loaders.from_vscode").lazy_load()
      require("luasnip.loaders.from_vscode").lazy_load({
        paths = { vim.fn.stdpath("config") .. "/snippets" }
      })
    end
  },

  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "saadparwaiz1/cmp_luasnip",
      "petertriho/cmp-git",
      "onsails/lspkind-nvim"
    },
    config = function()
      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      local luasnip = require("luasnip")
      local lspkind = require("lspkind")
      local cmp = require("cmp")

      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        formatting = {
          format = lspkind.cmp_format({
            mode = "symbol_text",
            menu = {
              buffer = "[Buf]",
              nvim_lsp = "[Lsp]",
              luasnip = "[Snip]",
              nvim_lua = "[Lua]",
              latex_symbols = "[Lat]",
            },
          }),
        },
        -- Show borders like the LSP autocomplte
        window = {
          completion = {
            border = "rounded",
          },
          documentation = {
            border = "rounded",
          },
        },
        experimental = {
          ghost_text = true,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
            -- they way you will only jump inside the snippet region
            elseif luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, { "i", "s" }),

          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp"},
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        })
      })

      cmp.setup.filetype("gitcommit", {
        sources = cmp.config.sources({
          { name = "cmp_git" },
          { name = "buffer" },
        })
      })
    end,
  },

  -- Replaces tpope/vim-surround
  {
    "kylechui/nvim-surround",
    config = true,
  },

  {
    "echasnovski/mini.nvim",
    version = false,
    config = function()
      -- Replaces tpope/vim-repeat
      require("mini.ai").setup()
      require("mini.comment").setup({
        hooks = {
          pre = function()
            require("ts_context_commentstring.internal").update_commentstring({})
          end,
        },
      })
      require("mini.bufremove").setup()
    end,
  },

  {
    "jose-elias-alvarez/null-ls.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      local null_ls = require("null-ls")
      local utils = require("null-ls.utils")

      null_ls.setup({
        root_dir = utils.root_pattern("composer.json", "package.json", "Makefile", ".git"), -- Add composer
        diagnostics_format = "#{m} (#{c}) [#{s}]",
        sources = {
          null_ls.builtins.completion.spell,
          null_ls.builtins.diagnostics.eslint,
          null_ls.builtins.diagnostics.phpcs.with({
            prefer_local = "vendor/bin",
          }),
          null_ls.builtins.formatting.stylua,
          null_ls.builtins.formatting.phpcbf.with({
            prefer_local = "vendor/bin",
          }),
        },
      })
    end,
  },

  {"folke/trouble.nvim", config = true},

  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      -- Hide tabline on dashboard
      vim.api.nvim_create_autocmd("User", {
          pattern = "AlphaReady",
          desc = "disable tabline for alpha",
          callback = function()
            vim.opt.showtabline = 0
          end,
      })
      vim.api.nvim_create_autocmd("BufUnload", {
          buffer = 0,
          desc = "enable tabline after alpha",
          callback = function()
              vim.opt.showtabline = 2
          end,
      })

      local is_unix = vim.fn.has("unix") == 1
      local is_win32 = vim.fn.has("win32") == 1
      local configure_path
      if is_unix then
        configure_path = "~/.config/nvim/init.lua"
      elseif is_win32 then
        configure_path = "~/AppData/Local/nvim/init.lua"
      end

      local dashboard = require("alpha.themes.dashboard")

      dashboard.section.header.val = {
        [[                                       .~JY~    ]],
        [[                                     :7JY5?.    ]],
        [[                                   ^?J!!Y7      ]],
        [[                  .7?!          .!J?^.!Y~       ]],
        [[                  !J~?7.      :7J7: .7Y^        ]],
        [[              .:^!J?.:??77777?J!.  :?J:         ]],
        [[          .:!?J?!~:.       ..:.   ^J?.          ]],
        [[        :7JJ!:.                  !J7.           ]],
        [[      ^JY?:                     .~77:           ]],
        [[    :J5?:                         .^!!^.        ]],
        [[   !55~                     .:^:     :~!~.      ]],
        [[  7P5:                                 .^~~:    ]],
        [[ ~PP:           .^^                       :~~^. ]],
        [[.5G?             ^!^.                       .~~.]],
        [[^GG:              :^~~^^::...               :~^ ]],
        [[!BG.                 ..:!!^^^^^^^^^::... .:^^:  ]],
        [[~BB:                   :!~       ...:::^^^:.    ]],
        [[.B#J                   ^!~                      ]],
        [[ ?##^                  ^7!                      ]],
        [[  5&B:                 .77.                     ]],
        [[   Y#B!                 !?~                     ]],
        [[    !G#5:               .7?:                    ]],
        [[     .7GBY^.             :??^                   ]],
        [[       .~JP5?^.           .7?~                  ]],
        [[          .^7JYJ?!~::......^JJ?.                ]],
        [[              ..^~!77777777!!~^                 ]],
      }

      -- dashboard.section.header.val = {
      --   [[ ██▀███   █    ██  ███▄    █ ██▒   █▓ ██▓ ███▄ ▄███▓]],
      --   [[▓██ ▒ ██▒ ██  ▓██▒ ██ ▀█   █▓██░   █▒▓██▒▓██▒▀█▀ ██▒]],
      --   [[▓██ ░▄█ ▒▓██  ▒██░▓██  ▀█ ██▒▓██  █▒░▒██▒▓██    ▓██░]],
      --   [[▒██▀▀█▄  ▓▓█  ░██░▓██▒  ▐▌██▒ ▒██ █░░░██░▒██    ▒██ ]],
      --   [[░██▓ ▒██▒▒▒█████▓ ▒██░   ▓██░  ▒▀█░  ░██░▒██▒   ░██▒]],
      --   [[░ ▒▓ ░▒▓░░▒▓▒ ▒ ▒ ░ ▒░   ▒ ▒   ░ ▐░  ░▓  ░ ▒░   ░  ░]],
      --   [[  ░▒ ░ ▒░░░▒░ ░ ░ ░ ░░   ░ ▒░  ░ ░░   ▒ ░░  ░      ░]],
      --   [[  ░░   ░  ░░░ ░ ░    ░   ░ ░     ░░   ▒ ░░      ░   ]],
      --   [[   ░        ░              ░      ░   ░         ░   ]],
      --   [[                                 ░                  ]]
      -- }
      dashboard.section.buttons.val = {
        dashboard.button("f", "  Find file", ":Telescope find_files <CR>"),
        dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
        dashboard.button("r", "  Recently used files", ":Telescope oldfiles <CR>"),
        dashboard.button("t", "  Find text", ":Telescope live_grep <CR>"),
        dashboard.button("c", "  Configuration", ":e" .. configure_path .. "<CR>"),
        dashboard.button("q", "  Quit Neovim", ":qa<CR>"),
      }

      dashboard.section.footer.opts.hl = "Type"
      dashboard.section.header.opts.hl = "Include"
      dashboard.section.buttons.opts.hl = "Keyword"
      dashboard.config.opts.noautocmd = true

      require('alpha').setup(dashboard.opts)
    end,
  },

  -----------------------------------------------------------------------------
  -- Appearance Plugins
  -----------------------------------------------------------------------------
  {
    "winston0410/range-highlight.nvim",
    config = true,
    dependencies = {
      "winston0410/cmd-parser.nvim",
    },
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
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("lualine").setup({
        options = {
          disabled_filetypes = {
            statusline = {
              "alpha",
              "NvimTree",
            },
          },
        },
      })
      require("nvim-web-devicons").setup()
    end,
  },

  {
    "akinsho/bufferline.nvim",
    version = "v3.*",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("bufferline").setup({
        options = {
          diagnostics = "nvim_lsp",
          offsets = {
            {
              filetype = "NvimTree",
              text = "File Explorer",
              text_align = "center",
              separator = true,
            }
          },
        }
      })
    end,
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      require('indent_blankline').setup({
        char = '┊',
        show_trailing_blankline_indent = false,
      })
    end
  },

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
    "stevearc/dressing.nvim",
    config = true,
  },
  {
    "mrded/nvim-lsp-notify",
    dependencies = {
      "rcarriga/nvim-notify",
    },
    config = function()
      require('lsp-notify').setup({
        notify = require('notify'),
      })
    end,
  },
  {
    "folke/noice.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    config = function()
      require("noice").setup({
        lsp = {
          -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
        },
        -- you can enable a preset for easier configuration
        presets = {
          bottom_search = true, -- use a classic bottom cmdline for search
          command_palette = true, -- position the cmdline and popupmenu together
          long_message_to_split = true, -- long messages will be sent to a split
          lsp_doc_border = true, -- add a border to hover docs and signature help
        },
      })
    end,
  },

  {
    "karb94/neoscroll.nvim",
    config = true,
  },

  -----------------------------------------------------------------------------
  -- Themes
  -----------------------------------------------------------------------------
  "ishan9299/nvim-solarized-lua",
  "marko-cerovac/material.nvim",
  "mhartington/oceanic-next",
  "shaunsingh/nord.nvim",
  { "catppuccin/nvim", name = "catppuccin" },
  "rebelot/kanagawa.nvim",
  "kvrohit/mellow.nvim",

  -----------------------------------------------------------------------------
  -- Language Specific Plugins
  -----------------------------------------------------------------------------
  {
    "gbprod/phpactor.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
    },
    config = function()
      require("phpactor").setup({
        install = {
          bin = vim.fn.stdpath("data") .. "/mason/bin/phpactor"
        },
      })
    end
  },

  "StanAngeloff/php.vim",
  "shawncplus/phpcomplete.vim",
  "adoy/vim-php-refactoring-toolbox",
  {
    "tobyS/pdv",
    dependencies = {
      "tobyS/vmustache",
    },
  },

  "othree/html5.vim",
  "lumiliet/vim-twig",

  -----------------------------------------------------------------------------
  -- Misc Plugins
  -----------------------------------------------------------------------------
  -- @NOTE: editorconfig is built into nvim 0.9, so this should be removed
  -- eventually.
  "gpanders/editorconfig.nvim",
  "jghauser/mkdir.nvim",
  "tpope/vim-fugitive",
  "tpope/vim-rhubarb",
  "tpope/vim-sleuth",
  "arouene/vim-ansible-vault",
  "godlygeek/tabular",
  {
    "lewis6991/gitsigns.nvim",
    config = true,
  },
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
})

-------------------------------------------------------------------------------
-- Vim Settings
-------------------------------------------------------------------------------
vim.g.mapleader = " "

-- Set completeopt to have a better completion experience
vim.opt.completeopt = "menuone,noselect"

-- Ensure the gutter is always open and 2 columns wide
vim.opt.signcolumn = "yes:2"

-- Load local configuration
vim.opt.exrc = true

-- More natural split positioning
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Sane Searching
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.gdefault = true
vim.opt.incsearch = true
vim.opt.showmatch = true
vim.opt.hlsearch = true

-- Show invisible characters with pretty symbols
vim.opt.list = true
vim.opt.listchars = {
  tab = "▸ ",
  eol = "¬",
}

-- Indentation Settings
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = false

-- Persistent undo
-- @TODO: port to lua
vim.cmd [[
silent execute "!mkdir ~/.config/nvim/undo > /dev/null 2>&1"
]]
vim.opt.undodir = vim.fn.stdpath("config") .. "/undo//"
vim.opt.undofile = true
vim.opt.undolevels = 1000
vim.opt.undoreload = 10000

-- Move swap and backup files into their own directory
-- @TODO: port to lua
vim.cmd [[
silent execute "!mkdir ~/.config/nvim/backup > /dev/null 2>&1"
silent execute "!mkdir ~/.config/nvim/swap > /dev/null 2>&1"
]]
vim.opt.backupdir = vim.fn.stdpath("config") .. "/backup//"
vim.opt.directory = vim.fn.stdpath("config") .. "/swap//"

-- The scrolloff (scroll offset) option determines the minimum number of screen
-- lines that you would like above and below the cursor.
vim.opt.scrolloff = 3

vim.opt.hidden = true
vim.opt.visualbell = true
vim.opt.cursorline = true
vim.opt.colorcolumn = "80"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"

-- vim.opt.syntax = "enable"
vim.opt.background = "dark"

vim.opt.termguicolors = true
vim.cmd "colorscheme solarized"

-- vim.cmd "colorscheme material"
-- vim.g.material_style = "deep ocean"

-- vim.opt.termguicolors = true
-- vim.cmd "colorscheme OceanicNext"

-- vim.cmd "colorscheme nord"

-- vim.cmd "colorscheme catppuccin-frappe"

-- vim.cmd "colorscheme kanagawa"

-- vim.cmd "colorscheme mellow"

-------------------------------------------------------------------------------
-- Plugin Settings
-------------------------------------------------------------------------------

-- Ansible Vault Settings
vim.g.ansible_vault_password_file = ".vault-id"
vim.g.ansible_vault_no_unquote = false

-- PDV Settings
vim.g.pdv_template_dir = vim.fn.stdpath("data") .. "/lazy/pdv/templates"

-- VDebug Settings
-- let g:vdebug_options = {
--     \ "port": 9003,
--     \ "break_on_open": 1,
--     \ "ide_key": "vim",
--     \ "server" : "",
--     \ "watch_window_style" : "compact",
--     \ "marker_default" : "*",
--     \ "path_maps" : { }
-- \}

-- Neomake Settings
-- let g:neomake_open_list = 2
-- let g:neomake_html_twig_enabled_makers = []
-- let g:neomake_jinja_html_twig_enabled_makers = []
-- let g:neomake_svelte_check_maker = {
--   \ "exe": "svelte-check",
--   \ "args": ["--output", "machine"],
--   \ "append_file": 0,
--   \ "errorformat":
--     \ '%E\\d%\\+ ERROR \"%f\" %l:%c \"%m\",' .
--     \ '%W%\\d%\\+ WARNING \"%f\" %l:%c \"%m\",' .
--     \ '%-G%.%#',
-- \}
-- let g:neomake_svelte_enabled_makers = ["svelte_check"]

-- Markdown Settings
-- let g:vim_markdown_frontmatter = 1
-- let g:vim_markdown_new_list_item_indent = 2
-- let g:vim_markdown_no_extensions_in_markdown = 1
-- let g:vim_markdown_folding_disabled = 1

-- Ranger Settings
-- let g:ranger_command_override = "ranger --cmd "set show_hidden=true""
-- let g:ranger_map_keys = 0

-- Rust Settings
-- let g:rustc_path = "~/.cargo/bin/rustc"

-------------------------------------------------------------------------------
-- Mappings
-------------------------------------------------------------------------------
local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then options = vim.tbl_extend("force", options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end
local function nmap(lhs, rhs, opts)
  map("n", lhs, rhs, opts)
end
local function imap(lhs, rhs, opts)
  map("i", lhs, rhs, opts)
end
local function vmap(lhs, rhs, opts)
  map("v", lhs, rhs, opts)
end


-------------------------------------------------------------------------------
-- Vim Mappings
-------------------------------------------------------------------------------

-- Disable arrow keys
nmap("<up>", "<nop>")
nmap("<down>", "<nop>")
nmap("<left>", "<nop>")
nmap("<right>", "<nop>")
imap("<up>", "<nop>")
imap("<down>", "<nop>")
imap("<left>", "<nop>")
imap("<right>", "<nop>")

-- Sane Searching
nmap("/", "/\\v")
vmap("/", "/\\v")

-- Toggle the last used buffer
nmap("qq", ":b#<cr>")

-- Quickly cycle through buffers
nmap("<tab>", ":bnext<cr>")
nmap("<s-tab>", ":bprevious<cr>")

-- Remap to gj/gk only if there is no count so that we can still use
-- relativenumber
nmap("j", "v:count ? 'j' : 'gj'", {expr = true})
nmap("k", "v:count ? 'k' : 'gk'", {expr = true})

-- Clear highlighted search
nmap("<leader><space>", ":noh<cr>")

-- Quickly set indentation
nmap("<leader>2", "<cmd>set tabstop=2 shiftwidth=2 softtabstop=2<cr>", {silent = true})
nmap("<leader>4", "<cmd>set tabstop=4 shiftwidth=4 softtabstop=4<cr>", {silent = true})
nmap("<leader>e", "<cmd>set expandtab<cr>", {silent = true})
nmap("<leader>ne", "<cmd>set noexpandtab<cr>", {silent = true})

-- Visually select the last pasted text
-- @TODO: port to lua
vim.cmd [[
nnoremap <expr> gb "`[" . strpart(getregtype(), 0, 1) . "`]"
]]

-- Yank to the system clipboard
vmap("<leader>y", '"+y')

-- Make enter the same as c-y in autocompletion menu
-- inoremap <expr> <cr> pumvisible() ? "\<c-y>" : "\<c-g>u\<cr>"

-- Quickly edit and source my vimrc
-- nnoremap <leader>ev :e $MYVIMRC<cr>
-- nnoremap <leader>sv :source $MYVIMRC<cr>

-- Close a buffer without closing the window
nmap("<leader>q", ":bp<bar>sp<bar>bn<bar>bd<CR>")

-- Create an edit file under cursor
nmap("<leader>gf", ":e <cfile><cr>")

-------------------------------------------------------------------------------
-- Plugin Mappings
-------------------------------------------------------------------------------

-- Ansible Vault
nmap("<leader>av", "<cmd>AnsibleVault<cr>")
nmap("<leader>au", "<cmd>AnsibleUnvault<cr>")

-- Neotree
nmap("<leader>t", "<cmd>NvimTreeFindFileToggle<cr>")

-- PhpActor
function expand_class()
  local rpc = require("phpactor.rpc")
  local word = vim.fn.expand("<cword>")

  rpc.call("class_search", {
    short_name = word,
  }, {
    callback = function(class_info)
      if class_info == nil then
        return
      end

      vim.cmd(string.format("normal! ciw\\%s", class_info["class"]))
    end,
  })
end
nmap("<leader>ce", ":lua expand_class()<cr>")

-- PDV
nmap("<leader>d", "<cmd>call pdv#DocumentCurrentLine()<cr>")

-- Telescope
nmap("<leader>o", "<cmd>Telescope find_files<cr>")
nmap("<leader>of", "<cmd>Telescope find_files search_dirs={'%:p:h'}<cr>")
nmap("<leader>b", "<cmd>Telescope buffers<cr>")

-- Ranger
-- nnoremap <leader>ro :RangerWorkingDirectory<cr>
-- nnoremap <leader>rf :RangerCurrentDirectory<cr>

-------------------------------------------------------------------------------
-- Autocommands
-------------------------------------------------------------------------------

vim.cmd [[
augroup vagrant
  autocmd!
  autocmd BufRead,BufNewFile Vagrantfile set filetype=ruby
augroup END

autocmd filetype crontab setlocal nobackup nowritebackup

" Drupal files
autocmd BufRead,BufNewFile *.module set filetype=php
autocmd BufRead,BufNewFile *.install set filetype=php
autocmd BufRead,BufNewFile *.inc set filetype=php
autocmd BufRead,BufNewFile *.profile set filetype=php
autocmd BufRead,BufNewFile *.theme set filetype=php
autocmd BufRead,BufNewFile *.engine set filetype=php
autocmd BufRead,BufNewFile *.test set filetype=php

autocmd BufRead,BufNewFile *.{info,make,build} set filetype=drini

" Detect YAML files with ---
autocmd BufNewFile,BufRead * if match(getline(1), "---") >= 0 && expand("%:e") != "md" | set filetype=yaml | endif

" Markdown
autocmd BufRead,BufNewFile *.md setlocal spell
autocmd BufRead,BufNewFile *.md setlocal tw=79

" Spell check git commits
autocmd FileType gitcommit setlocal spell

" Auto commit wiki files on save
autocmd BufWritePost ~/dotfiles/wiki/* call jobstart(["bash", "-c", "~/dotfiles/wiki/bin/commit " . expand("%")], {})

augroup PHP
  autocmd!
  " @TODO: not sure if this should be preserved from previous configs
  " autocmd FileType php setlocal iskeyword-=$
augroup END
]]
--
