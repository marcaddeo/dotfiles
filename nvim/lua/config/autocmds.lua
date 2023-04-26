-- Auto close nvim-tree on quit.
vim.api.nvim_create_autocmd("BufEnter", {
  group = vim.api.nvim_create_augroup("NvimTreeClose", {clear = true}),
  pattern = "NvimTree_*",
  callback = function()
    local layout = vim.api.nvim_call_function("winlayout", {})
    if layout[1] == "leaf" and vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(layout[2]), "filetype") == "NvimTree" and layout[3] == nil then vim.cmd("confirm quit") end
  end
})

vim.cmd [[
augroup vagrant
  autocmd!
  autocmd BufRead,BufNewFile Vagrantfile set filetype=ruby
augroup END

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
autocmd BufRead,BufNewFile *.md setlocal spell
autocmd BufRead,BufNewFile *.md setlocal tw=79

" Spell check git commits
autocmd FileType gitcommit setlocal spell

" Auto commit wiki files on save
autocmd BufWritePost ~/dotfiles/wiki/* call jobstart(["bash", "-c", "~/dotfiles/wiki/bin/commit " . expand("%")], {})


augroup PHP
  autocmd!
  " @TODO: not sure if this should be preserved from previous configs
  " autocmd FileType php setlocal iskeyword-=$
augroup END
]]
--
