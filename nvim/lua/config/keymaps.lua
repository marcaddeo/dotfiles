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
