return {
  {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      require('ibl').setup({
        scope = { enabled = false },
        indent = {
          char = "│",
          tab_char = "▸",
        },
        exclude = {
          filetypes = {
            "help",
            "alpha",
            "dashboard",
            "NvimTree",
            "Trouble",
            "lazy",
          },
        },
      })
    end
  },

  {
    "sigma-code/nvim-lsp-notify",
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
    "stevearc/dressing.nvim",
    config = true,
  },

  {
    "folke/noice.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      { "rcarriga/nvim-notify", opts = { background_colour = "#002b36" } },
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
    "winston0410/range-highlight.nvim",
    config = true,
    dependencies = {
      "winston0410/cmd-parser.nvim",
    },
  },

  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("lualine").setup({
        options = {
          globalstatus = true,
          disabled_filetypes = {
            statusline = {
              "alpha",
              "NvimTree",
            },
          },
        },
        extensions = { "nvim-tree" },
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
              highlight = "Directory"
            }
          },
        }
      })
    end,
  },

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
}
