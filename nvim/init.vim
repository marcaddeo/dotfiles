" Plugins
call plug#begin('~/.config/nvim/plugged')

" Enhancement Plugins
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'junegunn/fzf.vim'
Plug 'junegunn/fzf'

" Appearance Plugins
Plug 'altercation/vim-colors-solarized'
Plug 'vim-airline/vim-airline-themes'
Plug 'ryanoasis/vim-devicons'
Plug 'bling/vim-airline'

" Language Specific Plugins
Plug 'docteurklein/php-getter-setter.vim'
Plug 'shawncplus/phpcomplete.vim'
Plug 'kchmck/vim-coffee-script'
Plug 'elixir-lang/vim-elixir'
Plug 'groenewege/vim-less'
Plug 'evidens/vim-twig'
Plug 'tpope/vim-haml'
Plug 'derekwyatt/vim-scala'

" Misc Plugins
Plug 'christoomey/vim-tmux-navigator'
Plug 'editorconfig/editorconfig-vim'
" Plug 'ludovicchabant/vim-gutentags'
Plug 'Valloric/MatchTagAlways'
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-fugitive'
Plug 'godlygeek/tabular'
Plug 'majutsushi/tagbar'
Plug 'joonty/vdebug'

" Testing
Plug 'tpope/vim-commentary'
Plug 'benekastah/neomake'
Plug 'rbgrouleff/bclose.vim'
Plug 'plasticboy/vim-markdown'
Plug 'smerrill/vcl-vim-plugin'
Plug 'Glench/Vim-Jinja2-Syntax'
Plug 'rust-lang/rust.vim'
Plug 'cespare/vim-toml'
Plug 'francoiscabrol/ranger.vim'
Plug 'arouene/vim-ansible-vault'
Plug 'koryschneider/vim-trim'

" Plugins to find replacements for
Plug 'Valloric/YouCompleteMe', { 'do': './install.sh' }
"Plug 'scrooloose/nerdcommenter'
"Plug 'scrooloose/syntastic'

" Rarely used plugins, should look into removal
Plug 'wellle/visual-split.vim'

call plug#end()

" Settings
" General Settings
let mapleader = "\<space>"

" Load local configuration
set exrc
"
" More natural split positioning
set splitbelow
set splitright

" Sane Searching
set ignorecase
set smartcase
set gdefault
set incsearch
set showmatch
set hlsearch

" Show invisible characters with pretty symbols
set list
set listchars=tab:▸\ ,eol:¬

" Indentation Settings
set tabstop=4
set shiftwidth=4
set softtabstop=4
set noexpandtab
"
" Persistent undo
silent execute '!mkdir ~/.config/nvim/undo > /dev/null 2>&1'
set undodir=~/.config/nvim/undo//
set undofile
set undolevels=1000
set undoreload=10000

" Move swap and backup files into their own directory
silent execute '!mkdir ~/.config/nvim/backup > /dev/null 2>&1'
silent execute '!mkdir ~/.config/nvim/swap > /dev/null 2>&1'
set backupdir=~/.config/nvim/backup//
set directory=~/.config/nvim/swap//
"
" The scrolloff (scroll offset) option determines the minimum number of screen
" lines that you would like above and below the cursor.
set scrolloff=3

set hidden
set visualbell
set cursorline
set colorcolumn=80
set number
set relativenumber
set mouse=a

" Appearance Settings
syntax enable
set background=dark
colorscheme solarized

" Plugin Settings
" Airline settings
let g:airline#extensions#whitespace#mixed_indent_algo = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline_detect_paste = 1
let g:airline_detect_modified = 1
let g:airline_powerline_fonts = 1

" Syntastic Settings
let g:syntastic_php_checkers = ['php']

" Match Tag Always Settings
let g:mta_filetypes = {
    \ 'html' : 1,
    \ 'xhtml' : 1,
    \ 'xml' : 1,
    \ 'jinja' : 1,
    \ 'twig' : 1,
    \}

" VDebug Settings
let g:vdebug_options = {
    \ 'port': 9003,
    \ 'break_on_open': 1,
    \ 'ide_key': 'vim',
    \ 'server' : '',
    \ 'watch_window_style' : 'compact',
    \ 'marker_default' : '*',
    \ 'path_maps' : { }
\}

" Gutentags Settings
let g:gutentags_enabled = 1
let g:gutentags_ctags_executable_php = 'ctags --fields=+aimSl --languages=php'

" Autopairs Settings
let g:AutoPairsMultilineClose = 0
let g:AutoPairsCenterLine = 0

" Tagbar Settings
let g:tagbar_width = 55

" Neomake Settings
let g:neomake_open_list = 2

" Fzf Settings
let g:fzf_colors = {
  \ 'fg': ['fg', 'Normal'],
  \ 'bg': ['bg', 'Normal'],
  \ 'hl': ['fg', 'Identifier'],
  \ 'fg+': ['fg', 'Comment'],
  \ 'bg+': ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+': ['fg', 'Todo'],
  \ 'info': ['fg', 'PreProc'],
  \ 'prompt': ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker': ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header': ['fg', 'Comment']
\}

autocmd! VimEnter * command! -nargs=* -complete=file Ag :call fzf#vim#ag_raw(<q-args>)

" YCM Settings
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_seed_identifiers_with_syntax = 1
let g:ycm_collect_identifiers_from_comments_and_strings = 1
let g:ycm_collect_identifiers_from_tags_files = 1
let g:ycm_key_invoke_completion = '<c-o>'

" Ansible Vault Settings
let g:ansible_vault_password_file = '.vault-id'
let g:ansible_vault_no_unquote = 0

" Mappings
" Disable arrow keys
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

" Sane Searching
nnoremap / /\v
vnoremap / /\v

" Toggle the last used buffer
nnoremap qq :b#<cr>

" Quickly cycle through buffers
nnoremap <tab> :bnext<cr>
nnoremap <s-tab> :bprevious<cr>

" Remap to gj/gk only if there is no count so that we can still use
" relativenumber
nnoremap <expr> j v:count ? 'j' : 'gj'
nnoremap <expr> k v:count ? 'k' : 'gk'

" Clear highlighted search
nnoremap <leader><space> :noh<cr>

" Quickly set indentation
nnoremap <silent> <leader>2 :set tabstop=2 shiftwidth=2 softtabstop=2<cr>
nnoremap <silent> <leader>4 :set tabstop=4 shiftwidth=4 softtabstop=4<cr>
nnoremap <silent> <leader>e :set expandtab<cr>
nnoremap <silent> <leader>ne :set noexpandtab<cr>

" Visually select the last pasted text
nnoremap <expr> gb '`[' . strpart(getregtype(), 0, 1) . '`]'

" Ag
nnoremap K :Ag! "\b<c-r><c-w>\b"<cr>
vnoremap K y:Ag! "\b<c-r>"\b"<cr>
nnoremap \ :Ag<space>

" Fzf
nnoremap <leader>o :Files<cr>
nnoremap <leader>f :Files %:p:h<cr>
nnoremap <leader>m :History<cr>
nnoremap <leader>b :Buffers<cr>
nnoremap <leader>/ :BLines<cr>

" Ranger
let g:ranger_map_keys = 0
nnoremap <leader>ro :RangerWorkingDirectory<cr>
nnoremap <leader>rf :RangerCurrentDirectory<cr>

" Tagbar
nnoremap <leader>t :TagbarOpenAutoClose<cr>

" Ansible Vault
nnoremap <Leader>av :AnsibleVault<CR>
nnoremap <Leader>au :AnsibleUnvault<CR>

" Yank to the system clipboard
vmap <leader>y "+y

" Make enter the same as c-y in autocompletion menu
inoremap <expr> <cr> pumvisible() ? "\<c-y>" : "\<c-g>u\<cr>"

" Quickly edit and source my vimrc
nnoremap <leader>ev :e $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

" Close a buffer without closing the window
nnoremap <leader>q :bp<bar>sp<bar>bn<bar>bd<CR>

" Create an edit file under cursor
nnoremap <leader>gf :e <cfile><cr>

" Autocommands
augroup vagrant
  au!
  au BufRead,BufNewFile Vagrantfile set filetype=ruby
augroup END

autocmd filetype crontab setlocal nobackup nowritebackup

" Set filetype for Drupal PHP files.
autocmd BufRead,BufNewFile *.module set filetype=php
autocmd BufRead,BufNewFile *.install set filetype=php
autocmd BufRead,BufNewFile *.inc set filetype=php
autocmd BufRead,BufNewFile *.profile set filetype=php
autocmd BufRead,BufNewFile *.theme set filetype=php
autocmd BufRead,BufNewFile *.engine set filetype=php
autocmd BufRead,BufNewFile *.test set filetype=php
autocmd BufRead,BufNewFile *.{info,make,build} set filetype=drini

" Detect YAML files with ---
autocmd BufNewFile,BufRead * if match(getline(1), "---") >= 0 && expand('%:e') != "md" | set filetype=yaml | endif

" Run Neomake on every write
autocmd! BufWritePost * Neomake

" Markdown settings
autocmd BufRead,BufNewFile *.md setlocal spell
autocmd BufRead,BufNewFile *.md setlocal tw=79

" Spell check git commits
autocmd FileType gitcommit setlocal spell

autocmd BufWritePost ~/dotfiles/wiki/* call jobstart(['bash', '-c', '~/dotfiles/wiki/bin/commit ' . expand('%')], {})

nnoremap <leader>wt :silent r !date +'\%n\# \%H:\%M\%n'<cr>i

let g:vim_markdown_frontmatter = 1
let g:vim_markdown_new_list_item_indent = 2
let g:vim_markdown_no_extensions_in_markdown = 1
let g:vim_markdown_folding_disabled = 1
