return {
  {
    "L3MON4D3/LuaSnip",
    version = "v1.*",
    build = "make install_jsregexp",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    config = function()
      local luasnip = require("luasnip")

      luasnip.filetype_extend("twig", {"twig"})

      -- @TODO: custom snippets arent working or are they? didn't i fix this?
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
          { name = "nvim_lsp" },
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
      require("mini.bufremove").setup()
    end,
  },

  "tpope/vim-commentary",

  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
  },

  {
    "mfussenegger/nvim-dap",
    config = function()
      local dap = require("dap")

      dap.adapters.php = {
        type = "executable",
        command = "node",
        args = { vim.fn.stdpath("data") .. "/dapinstall/php/vscode-php-debug/out/phpDebug.js" }
      }
      dap.configurations.php = {
        {
          type = "php",
          request = "launch",
          name = "Listen for Xdebug",
          port = 9003,
          pathMappings = {
            ["/app"] = "${workspaceFolder}"
          }
        }
      }
    end
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap"
    },
    opts = {
      layouts = {
        {
          elements = {
            {
              id = "scopes",
              size = 0.25
            },
            {
              id = "breakpoints",
              size = 0.25
            },
            {
              id = "stacks",
              size = 0.25
            },
            {
              id = "watches",
              size = 0.25
            }
          },
          position = "right",
          size = 40
        },
        {
          elements = {
            {
              id = "repl",
              size = 0.5
            },
            {
              id = "console",
              size = 0.5
            }
          },
          position = "bottom",
          size = 10
        }
      },
    },
    config = function(_, opts)
      local dap, dapui = require("dap"), require("dapui")
      dapui.setup(opts)

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end
  },
  {
    "folke/neodev.nvim",
    opts = {
      library = { plugins = { "nvim-dap-ui" }, types = true }
    }
  },
  { "theHamsta/nvim-dap-virtual-text", config = true },
}
