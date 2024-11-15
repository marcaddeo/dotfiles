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

-- Tmux Navigation.
nmap("<C-h>", "<cmd>lua require'tmux'.move_left()<cr>", { desc = "Go to left window" })
nmap("<C-j>", "<cmd>lua require'tmux'.move_bottom()<cr>", { desc = "Go to lower window" })
nmap("<C-k>", "<cmd>lua require'tmux'.move_top()<cr>", { desc = "Go to upper window" })
nmap("<C-l>", "<cmd>lua require'tmux'.move_right()<cr>", { desc = "Go to right window" })

-- Yank to the system clipboard.
vmap("<leader>y", '"+y', { desc = "Yank to the system clipboard" })

-- Toggle the last used buffer
nmap("qq", ":b#<cr>", { desc = "Go to the last used buffer", silent = true })

-- Quickly cycle through buffers
-- @TODO these are actually slow for some reason when compared to <s-h> and
-- <s-l> which use BufferlinePrevious/Next command_params
-- @TODO disabling and trying to get used to <s-h> and <s-l>
-- nmap("<tab>", ":bnext<cr>", { desc = "Go to the next buffer", silent = true })
-- nmap("<s-tab>", ":bprevious<cr>", { desc = "Go to the previous buffer", silent = true })

-- Visually select the last pasted text
nmap("gb", function()
  vim.api.nvim_feedkeys("`[" .. vim.fn.getregtype():sub(1, 1) .. "`]", "n", false)
end, { desc = "Visually select the last pasted text", silent = true })

-- Close a buffer without closing the window
-- @TODO disabling for now, since it conflicts with the `<leader>q` namespace
-- that lazyvim adds.
-- @note Use <leader>bd instead.
-- nmap("<leader>q", ":bp<bar>sp<bar>bn<bar>bd<CR>", { desc = "Close a buffer (without closing the window)" })
