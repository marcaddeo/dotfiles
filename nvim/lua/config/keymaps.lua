-------------------------------------------------------------------------------
-- Mappings
-------------------------------------------------------------------------------
local function map(mode, lhs, rhs, opts)
	local options = { noremap = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	-- vim.api.nvim_set_keymap(mode, lhs, rhs, options)
	vim.keymap.set(mode, lhs, rhs, options)
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
-- map({ "n", "i" }, "<up>", "<nop>")
-- map({ "n", "i" }, "<down>", "<nop>")
-- map({ "n", "i" }, "<left>", "<nop>")
-- map({ "n", "i" }, "<right>", "<nop>")

-- Sane Searching
map({ "n", "v" }, "/", "/\\v")

-- Toggle the last used buffer
nmap("qq", ":b#<cr>", { desc = "Go to the last used buffer", silent = true })

-- Quickly cycle through buffers
nmap("<tab>", ":bnext<cr>", { desc = "Go to the next buffer", silent = true })
nmap("<s-tab>", ":bprevious<cr>", { desc = "Go to the previous buffer", silent = true })

-- Remap to gj/gk only if there is no count so that we can still use
-- relativenumber
nmap("j", "v:count ? 'j' : 'gj'", { expr = true })
nmap("k", "v:count ? 'k' : 'gk'", { expr = true })

-- Clear highlighted search
nmap("<leader><space>", function()
	require("notify").dismiss({ silent = true, pending = true })
	vim.cmd("noh")
end, { desc = "Clear notifications and search results", silent = true })

-- Quickly set indentation
nmap(
	"<leader>2",
	"<cmd>set tabstop=2 shiftwidth=2 softtabstop=2<cr>",
	{ desc = "Set indentation level to 2", silent = true }
)
nmap(
	"<leader>4",
	"<cmd>set tabstop=4 shiftwidth=4 softtabstop=4<cr>",
	{ desc = "Set indentation level to 4", silent = true }
)
nmap("<leader>e", "<cmd>set expandtab<cr>", { desc = "Expand tab to spaces", silent = true })
nmap("<leader>ne", "<cmd>set noexpandtab<cr>", { desc = "Do not expand tab to spaces", silent = true })

-- Visually select the last pasted text
nmap("gb", function()
	vim.api.nvim_feedkeys("`[" .. vim.fn.getregtype():sub(1, 1) .. "`]", "n", false)
end, { desc = "Visually select the last pasted text", silent = true })

-- Yank to the system clipboard
vmap("<leader>y", '"+y', { desc = "Yank to the system clipboard" })

-- Make enter the same as c-y in autocompletion menu
-- inoremap <expr> <cr> pumvisible() ? "\<c-y>" : "\<c-g>u\<cr>"

-- Quickly edit and source my vimrc
-- nnoremap <leader>ev :e $MYVIMRC<cr>
-- nnoremap <leader>sv :source $MYVIMRC<cr>

-- Close a buffer without closing the window
nmap(
	"<leader>q",
	":bp<bar>sp<bar>bn<bar>bd<CR>",
	{ desc = "Close a buffer (without closing the window)", silent = true }
)

-- Create an edit file under cursor
nmap("<leader>gf", ":e <cfile><cr>", { desc = "Create and edit file under cursor", silent = true })

-- Open lazygit
nmap("<leader>gg", function()
	require("lazy.util").float_term("lazygit", { width = 0.9, height = 0.9 })
end, { desc = "Open LazyGit", silent = true })

-------------------------------------------------------------------------------
-- Plugin Mappings
-------------------------------------------------------------------------------

-- Ansible Vault
nmap("<leader>av", "<cmd>AnsibleVault<cr>", { desc = "Encrypt using Ansible Vault", silent = true })
nmap("<leader>au", "<cmd>AnsibleUnvault<cr>", { desc = "Decrypt using Ansible Vault", silent = true })

-- Neotree
nmap("<leader>t", "<cmd>NvimTreeFindFileToggle<cr>", { desc = "Open File Exporer at current file", silent = true })

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
nmap(
	"<leader>ce",
	":lua expand_class()<cr>",
	{ desc = "Expand PHP class to the FQCN, prefixed with \\", silent = true }
)
nmap("<leader>ic", "<cmd>PhpActor import_class<cr>", { desc = "Import PHP class under cursor", silent = true })

-- PDV
nmap(
	"<leader>d",
	"<cmd>call pdv#DocumentCurrentLine()<cr>",
	{ desc = "Add a PHPDoc for the current line", silent = true }
)

-- Telescope
nmap("<leader>o", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in project", silent = true })
nmap(
	"<leader>of",
	"<cmd>Telescope find_files search_dirs={'%:p:h'}<cr>",
	{ desc = "Fuzzy find files at current files path", silent = true }
)
nmap("<leader>b", "<cmd>Telescope buffers<cr>", { desc = "Fuzzy find buffers", silent = true })

--- DAP
nmap("<F5>", function()
	require("dap").continue()
end, { desc = "Debugger: Continue" })
nmap("<F10>", function()
	require("dap").step_over()
end, { desc = "Debugger: Step Over" })
nmap("<F11>", function()
	require("dap").step_into()
end, { desc = "Debugger: Step Into" })
nmap("<F12>", function()
	require("dap").step_out()
end, { desc = "Debugger: Step Out" })
nmap("<leader>bp", function()
	require("dap").toggle_breakpoint()
end, { desc = "Debugger: Toggle Breakpoint" })
nmap("<leader>bP", function()
	require("dap").set_breakpoint()
end, { desc = "Debugger: Set Breakpoint" })
nmap("<leader>lp", function()
	require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
end, { desc = "Debugger: Set Log point" })
nmap("<leader>dr", function()
	require("dap").repl_open()
end, { desc = "Debugger: Open REPL" })
nmap("<leader>dl", function()
	require("dap").run_last()
end, { desc = "Debugger: Run Last" })
nmap("<leader>dut", function()
	require("dapui").toggle()
end, { desc = "Debugger: Toggle UI" })
map({ "n", "v" }, "<leader>dh", function()
	require("dap.ui.widgets").hover()
end, { desc = "Debugger: Hover" })
map({ "n", "v" }, "<leader>dp", function()
	require("dap.ui.widgets").preview()
end, { desc = "Debugger: Preview" })
map({ "n", "v" }, "<leader>df", function()
	local widgets = require("dap.ui.widgets")
	widgets.centered_float(widgets.frames)
end, { desc = "Debugger: Frames" })
map({ "n", "v" }, "<leader>ds", function()
	local widgets = require("dap.ui.widgets")
	widgets.centered_float(widgets.scopes)
end, { desc = "Debugger: Scopes" })

-- Ranger
-- nnoremap <leader>ro :RangerWorkingDirectory<cr>
-- nnoremap <leader>rf :RangerCurrentDirectory<cr>

-- nmap("<leader>cf", "cW=system('/Users/marc/dotfiles/nvim/css-filter-genrator.js ' . shellescape(expand('<cWORD>')))<cr>")
-- nmap("<leader>cf", ":execute !'/Users/marc/dotfiles/nvim/css-filter-genrator.js ' . shellescape(expand('<cWORD>'))<cr>")
