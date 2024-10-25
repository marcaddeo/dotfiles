-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
vim.cmd([[
" Crontab.
autocmd filetype crontab setlocal nobackup nowritebackup

" Drupal files
autocmd BufRead,BufNewFile *.module set filetype=php
autocmd BufRead,BufNewFile *.install set filetype=php
autocmd BufRead,BufNewFile *.inc set filetype=php
autocmd BufRead,BufNewFile *.profile set filetype=php
autocmd BufRead,BufNewFile *.theme set filetype=php
autocmd BufRead,BufNewFile *.engine set filetype=php
autocmd BufRead,BufNewFile *.test set filetype=php
autocmd BufRead,BufNewFile *.{info,make,build} set filetype=drini

" Detect YAML files with ---
autocmd BufNewFile,BufRead * if match(getline(1), "^---$") >= 0 && expand("%:e") != "md" | set filetype=yaml | endif

" Markdown
" @TODO testing without for now
" autocmd BufRead,BufNewFile *.md setlocal spell
" autocmd BufRead,BufNewFile *.md setlocal tw=79

" Rust
autocmd BufRead,BufNewFile *.rs setlocal colorcolumn=100

" Spell check git commits
autocmd FileType gitcommit setlocal spell
]])
--
