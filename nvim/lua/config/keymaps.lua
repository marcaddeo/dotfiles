-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local function map(mode, lhs, rhs, opts)
  local keys = require("lazy.core.handler").handlers.keys
  ---@cast keys LazyKeysHandler
  -- do not create the keymap if a lazy keys handler exists
  if not keys.active[keys.parse({ lhs, mode = mode }).id] then
    opts = opts or {}
    opts.silent = opts.silent ~= false
    vim.keymap.set(mode, lhs, rhs, opts)
  end
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

nmap("<C-h>", "<cmd>lua require'tmux'.move_left()<cr>", { desc = "Go to left window" })
nmap("<C-j>", "<cmd>lua require'tmux'.move_bottom()<cr>", { desc = "Go to lower window" })
nmap("<C-k>", "<cmd>lua require'tmux'.move_top()<cr>", { desc = "Go to upper window" })
nmap("<C-l>", "<cmd>lua require'tmux'.move_right()<cr>", { desc = "Go to right window" })

-- Toggle the last used buffer
nmap("qq", ":b#<cr>", { desc = "Go to the last used buffer", silent = true })

-- Quickly cycle through buffers
nmap("<tab>", ":bnext<cr>", { desc = "Go to the next buffer", silent = true })
nmap("<s-tab>", ":bprevious<cr>", { desc = "Go to the previous buffer", silent = true })
