-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.g.updatetime = 100

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

vim.diagnostic.config({
	float = { border = "rounded" },
})

-------------------------------------------------------------------------------
-- Vim Settings
-------------------------------------------------------------------------------
vim.g.mapleader = " "

-- Set completeopt to have a better completion experience
vim.opt.completeopt = "menuone,noselect" -- menu,menuone,noselect = lazyvim

-- Ensure the gutter is always open and 2 columns wide
vim.opt.signcolumn = "yes"

-- Load local configuration
vim.opt.exrc = true

-- More natural split positioning
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Sane Searching
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.gdefault = true -- not on
vim.opt.incsearch = true
vim.opt.showmatch = true -- not on
vim.opt.hlsearch = true

-- Show invisible characters with pretty symbols
vim.opt.list = true -- added to new setup
vim.opt.listchars = { -- added to new setup
	tab = "▸ ",
	eol = "¬",
}
-- Hide end of buffer characters
vim.opt.fillchars = {
	eob = " ",
}

-- Indentation Settings
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = false

-- Persistent undo
-- @TODO: port to lua
vim.cmd([[
silent execute "!mkdir ~/.config/nvim/undo > /dev/null 2>&1"
]])
vim.opt.undodir = vim.fn.stdpath("config") .. "/undo//"
vim.opt.undofile = true
vim.opt.undolevels = 1000
vim.opt.undoreload = 10000

-- Move swap and backup files into their own directory
-- @TODO: port to lua
vim.cmd([[
silent execute "!mkdir ~/.config/nvim/backup > /dev/null 2>&1"
silent execute "!mkdir ~/.config/nvim/swap > /dev/null 2>&1"
]])
vim.opt.backupdir = vim.fn.stdpath("config") .. "/backup//"
vim.opt.directory = vim.fn.stdpath("config") .. "/swap//"

-- The scrolloff (scroll offset) option determines the minimum number of screen
-- lines that you would like above and below the cursor.
vim.opt.scrolloff = 3

vim.opt.hidden = true
vim.opt.visualbell = true
vim.opt.cursorline = true
vim.opt.colorcolumn = "80" -- added to new setup
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"

vim.opt.background = "dark"

-------------------------------------------------------------------------------
-- Plugin Settings
-------------------------------------------------------------------------------

-- Ansible Configuration
vim.g.ansible_vault_password_file = ".vault-id"
vim.g.ansible_vault_no_unquote = false

-- PDV Configuration
vim.g.pdv_template_dir = vim.fn.stdpath("data") .. "/lazy/pdv/templates"

-- VDebug Settings
-- let g:vdebug_options = {
--     \ "port": 9003,
--     \ "break_on_open": 1,
--     \ "ide_key": "vim",
--     \ "server" : "",
--     \ "watch_window_style" : "compact",
--     \ "marker_default" : "*",
--     \ "path_maps" : { }
-- \}

-- Neomake Settings
-- let g:neomake_open_list = 2
-- let g:neomake_html_twig_enabled_makers = []
-- let g:neomake_jinja_html_twig_enabled_makers = []
-- let g:neomake_svelte_check_maker = {
--   \ "exe": "svelte-check",
--   \ "args": ["--output", "machine"],
--   \ "append_file": 0,
--   \ "errorformat":
--     \ '%E\\d%\\+ ERROR \"%f\" %l:%c \"%m\",' .
--     \ '%W%\\d%\\+ WARNING \"%f\" %l:%c \"%m\",' .
--     \ '%-G%.%#',
-- \}
-- let g:neomake_svelte_enabled_makers = ["svelte_check"]

-- Markdown Settings
-- let g:vim_markdown_frontmatter = 1
-- let g:vim_markdown_new_list_item_indent = 2
-- let g:vim_markdown_no_extensions_in_markdown = 1
-- let g:vim_markdown_folding_disabled = 1

-- Ranger Settings
-- let g:ranger_command_override = "ranger --cmd "set show_hidden=true""
-- let g:ranger_map_keys = 0

-- Rust Settings
-- let g:rustc_path = "~/.cargo/bin/rustc"
