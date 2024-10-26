return {
  -- LazyVim overrides.

  -- Change the alpha-nvim dashboard logo.
  {
    "goolord/alpha-nvim",
    opts = function(_, dashboard)
      dashboard.section.header.val = {
        [[ ██▀███   █    ██  ███▄    █ ██▒   █▓ ██▓ ███▄ ▄███▓]],
        [[▓██ ▒ ██▒ ██  ▓██▒ ██ ▀█   █▓██░   █▒▓██▒▓██▒▀█▀ ██▒]],
        [[▓██ ░▄█ ▒▓██  ▒██░▓██  ▀█ ██▒▓██  █▒░▒██▒▓██    ▓██░]],
        [[▒██▀▀█▄  ▓▓█  ░██░▓██▒  ▐▌██▒ ▒██ █░░░██░▒██    ▒██ ]],
        [[░██▓ ▒██▒▒▒█████▓ ▒██░   ▓██░  ▒▀█░  ░██░▒██▒   ░██▒]],
        [[░ ▒▓ ░▒▓░░▒▓▒ ▒ ▒ ░ ▒░   ▒ ▒   ░ ▐░  ░▓  ░ ▒░   ░  ░]],
        [[  ░▒ ░ ▒░░░▒░ ░ ░ ░ ░░   ░ ▒░  ░ ░░   ▒ ░░  ░      ░]],
        [[  ░░   ░  ░░░ ░ ░    ░   ░ ░     ░░   ▒ ░░      ░   ]],
        [[   ░        ░              ░      ░   ░         ░   ]],
        [[                                 ░                  ]],
      }
      return dashboard
    end,
  },
  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        always_show_bufferline = true,
      },
    },
  },

  -- Custom additions.

  -- Solarized (autumn) theme.
  {
    "maxmx03/solarized.nvim",
    lazy = false,
    priority = 1000,
    ---@type solarized.config
    opts = {
      variant = "autumn",
    },
    config = function(_, opts)
      vim.o.termguicolors = true
      vim.o.background = "dark"
      require("solarized").setup(opts)
      vim.cmd.colorscheme("solarized")
    end,
  },
  {
    "winston0410/range-highlight.nvim",
    dependencies = {
      "winston0410/cmd-parser.nvim",
    },
    config = true,
  },
}
