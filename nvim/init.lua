require("config.options")
require("config.autocmds")
require("config.keymaps")

-- bootstrap lazy.nvim and plugins
require("config.lazy")

-- @TODO: maybe a colorscheme_manager?
vim.cmd "colorscheme solarized"

-- vim.cmd "colorscheme material"
-- vim.g.material_style = "deep ocean"

-- vim.opt.termguicolors = true
-- vim.cmd "colorscheme OceanicNext"

-- vim.cmd "colorscheme nord"

-- vim.cmd "colorscheme catppuccin-frappe"

-- vim.cmd "colorscheme kanagawa"

-- vim.cmd "colorscheme mellow"
