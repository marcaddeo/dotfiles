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
Plug 'groenewege/vim-less' " Less hilighting
Plug 'evidens/vim-twig'
Plug 'tpope/vim-haml'

" Misc Plugins
Plug 'Valloric/YouCompleteMe', { 'do': './install.sh' }
Plug 'christoomey/vim-tmux-navigator'
Plug 'editorconfig/editorconfig-vim'
Plug 'ludovicchabant/vim-gutentags'
Plug 'Valloric/MatchTagAlways'
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-fugitive'
Plug 'godlygeek/tabular'
Plug 'joonty/vdebug'

" Plugins to find replacements for
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/syntastic'

" Rarely used plugins, should look into removal
Plug 'wellle/visual-split.vim'
Plug 'gcmt/wildfire.vim'

call plug#end()

" Settings
" General Settings
let mapleader = "\<space>"
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
    \ 'break_on_open': 1,
    \ 'ide_key': 'XDEBUG_VIM',
    \ 'server' : '',
    \ 'watch_window_style' : 'compact',
    \ 'marker_default' : '*',
    \ 'path_maps' : {
        \ '/theme/cle' : '/Users/marc/dev/oomph/ccl-leading-effectively/cle',
        \ '/app' : '/Users/marc/dev/oomph/Boston-Chefs',
        \ '/app/boston-chefs' : '/Users/marc/dev/oomph/Boston-Chefs/boston-chefs',
        \ '/var/www/index.php' : '/Users/marc/dev/oomph/wp/index.php',
        \ '/var/www/wp-activate.php' : '/Users/marc/dev/oomph/wp/wp-activate.php',
        \ '/var/www/wp-admin' : '/Users/marc/dev/oomph/wp/wp-admin',
        \ '/var/www/wp-blog-header.php' : '/Users/marc/dev/oomph/wp/wp-blog-header.php',
        \ '/var/www/wp-comments-post.php' : '/Users/marc/dev/oomph/wp/wp-comments-post.php',
        \ '/var/www/wp-config-sample.php' : '/Users/marc/dev/oomph/wp/wp-config-sample.php',
        \ '/var/www/wp-content' : '/Users/marc/dev/oomph/wp/wp-content',
        \ '/var/www/wp-cron.php' : '/Users/marc/dev/oomph/wp/wp-cron.php',
        \ '/var/www/wp-includes' : '/Users/marc/dev/oomph/wp/wp-includes',
        \ '/var/www/wp-links-opml.php' : '/Users/marc/dev/oomph/wp/wp-links-opml.php',
        \ '/var/www/wp-load.php' : '/Users/marc/dev/oomph/wp/wp-load.php',
        \ '/var/www/wp-login.php' : '/Users/marc/dev/oomph/wp/wp-login.php',
        \ '/var/www/wp-mail.php' : '/Users/marc/dev/oomph/wp/wp-mail.php',
        \ '/var/www/wp-settings.php' : '/Users/marc/dev/oomph/wp/wp-settings.php',
        \ '/var/www/wp-signup.php' : '/Users/marc/dev/oomph/wp/wp-signup.php',
        \ '/var/www/wp-trackback.php' : '/Users/marc/dev/oomph/wp/wp-trackback.php',
        \ '/var/www/xmlrpc.php' : '/Users/marc/dev/oomph/wp/xmlrpc.php',
        \ '/var/www/docroot' : '/Users/marc/dev/oomph/blue365/docroot',
        \ '/var/www/blue365deals.dev/docroot' : '/Users/marc/dev/oomph/blue365deals.com/docroot',
        \ '/vagrant' : '/Users/marc/dev/oomph/blue365deals.com',
        \ '/usr/share/php/drush' : '/Users/marc/.composer/vendor/drush/drush',
        \ '/var/www/web' : '/Users/marc/dev/oomph/oomphinc.com/web'
    \}
\}

" Gutentags Settings
let g:gutentags_enabled = 1
let g:gutentags_ctags_executable_php = 'ctags --fields=+aimSl --languages=php'

" Autopairs Settings
let g:AutoPairsMultilineClose = 0
let g:AutoPairsCenterLine = 0

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
nnoremap qq :e#<CR>

" Quickly cycle through buffers with Tab and S-Tab
nnoremap <Tab> :bnext<CR>
nnoremap <S-Tab> :bprevious<CR>

" Remap to gj/gk only if there is no count so that we can still use
" relativenumber
nnoremap <expr> j v:count ? 'j' : 'gj'
nnoremap <expr> k v:count ? 'k' : 'gk'

" Clear search with <leader><space>
nnoremap <leader><space> :noh<cr>

" Quickly set indentation with these mappings
nnoremap <silent> <Leader>2 :set tabstop=2 shiftwidth=2 softtabstop=2<CR>
nnoremap <silent> <Leader>4 :set tabstop=4 shiftwidth=4 softtabstop=4<CR>
nnoremap <silent> <Leader>e :set expandtab<CR>
nnoremap <silent> <Leader>ne :set noexpandtab<CR>

" Map gb to select the last pasted text, visually
nnoremap <expr> gb '`[' . strpart(getregtype(), 0, 1) . '`]'

" Ag
nnoremap K :Ag! "\b<C-R><C-W>\b"<CR>
vnoremap K y:Ag! "\b<C-R>"\b"<CR>
nnoremap \ :Ag<SPACE>

" Fzf
nnoremap <leader>f :Files<CR>
nnoremap <leader>b :Buffers<CR>

" Make enter the same as C-Y in autocompletion menu
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Autocommands
augroup vagrant
  au!
  au BufRead,BufNewFile Vagrantfile set filetype=ruby
augroup END

" Set filetype for Drupal PHP files.
autocmd BufRead,BufNewFile *.module set filetype=php
autocmd BufRead,BufNewFile *.install set filetype=php
autocmd BufRead,BufNewFile *.inc set filetype=php
autocmd BufRead,BufNewFile *.profile set filetype=php
autocmd BufRead,BufNewFile *.theme set filetype=php
autocmd BufRead,BufNewFile *.engine set filetype=php
autocmd BufRead,BufNewFile *.test set filetype=php
autocmd BufRead,BufNewFile *.{info,make,build} set filetype=drini
