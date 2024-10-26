-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.lazygit_config = false

local opt = vim.opt

-- Enable line wrap.
-- @TODO consider removing <leader>uw
opt.wrap = true

-- Enable list chars to make incorrect characters stand out.
opt.list = true
-- Trying out a new tab character than i normally use, usually use:
--   tab = "▸ ",
-- @see https://vi.stackexchange.com/questions/422/how-can-i-display-tabs-as-characters
opt.listchars = {
  tab = "⍿·",
  eol = "¬",
}

-- Enable color column so we visually see max line length.
opt.colorcolumn = "80"

-- Load local vim config files for project-level configuration overrides.
opt.exrc = true
