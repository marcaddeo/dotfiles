return {
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
}
