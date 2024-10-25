-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
local opt = vim.opt

opt.wrap = true -- Enable line wrap @TODO consider removing <leader>uw

opt.list = true -- Enable list chars to make incorrect characters stand out
-- Trying out a new tab character than i normally use, usually use:
--   tab = "▸ ",
-- @see https://vi.stackexchange.com/questions/422/how-can-i-display-tabs-as-characters
opt.listchars = {
  tab = "⍿·",
  eol = "¬",
}
