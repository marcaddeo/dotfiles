call plug#begin('~/.nvim/plugged')

Plug 'bling/vim-airline'
Plug 'altercation/vim-colors-solarized'
Plug 'Shougo/unite.vim'
Plug 'Shougo/vimfiler.vim'
Plug 'ryanoasis/vim-devicons'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': 'yes \| ./install' }
Plug 'junegunn/fzf.vim'
Plug 'rking/ag.vim'
Plug 'Valloric/YouCompleteMe', { 'do': './install.sh' }
Plug 'godlygeek/tabular'
Plug 'tpope/vim-repeat'
Plug 'scrooloose/nerdcommenter'
Plug 'tpope/vim-surround'
Plug 'scrooloose/syntastic'
Plug 'joonty/vdebug'
Plug 'elixir-lang/vim-elixir'
Plug 'gcmt/wildfire.vim'
Plug 'Valloric/MatchTagAlways'
Plug 'Raimondi/delimitMate'
Plug 'groenewege/vim-less' " Less hilighting
Plug 'christoomey/vim-tmux-navigator'
Plug 'shawncplus/phpcomplete.vim'
Plug 'ludovicchabant/vim-gutentags'
Plug 'tpope/vim-fugitive'
Plug 'kchmck/vim-coffee-script'
Plug 'tpope/vim-haml'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

call plug#end()

let mapleader = ","

syntax enable
set background=dark
colorscheme solarized

augroup reload_vimrc
    autocmd!
    autocmd BufWritePost $MYVIMRC source $MYVIMRC
augroup END

" Toggle the last used buffer
nnoremap qq :e#<CR>

" Airline settings
let g:airline#extensions#whitespace#mixed_indent_algo = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline_detect_paste = 1
let g:airline_detect_modified = 1
let g:airline_powerline_fonts = 1

" Disable arrow keys
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

" Remap to gj/gk only if there is no count so that we can still use
" relativenumber
nnoremap <expr> j v:count ? 'j' : 'gj'
nnoremap <expr> k v:count ? 'k' : 'gk'

" Clear search with <leader><space>
nnoremap <leader><space> :noh<cr>

" Vimfiler
let g:vimfiler_as_default_explorer = 1
let g:vimfiler_ignore_pattern = ['^\.git$', '^\.DS_Store$', '^\.vagrant$']
nnoremap <silent> <Leader>x :VimFilerExplorer<CR>

" Show invisible characters with pretty symbols
set list
set listchars=tab:▸\ ,eol:¬

" Set our tab widths
set tabstop=4
set shiftwidth=4
set softtabstop=4
set noexpandtab

nnoremap <silent> <Leader>2 :set tabstop=2 shiftwidth=2 softtabstop=2<CR>
nnoremap <silent> <Leader>4 :set tabstop=4 shiftwidth=4 softtabstop=4<CR>
nnoremap <silent> <Leader>e :set expandtab<CR>
nnoremap <silent> <Leader>ne :set noexpandtab<CR>

" Map gb to select the last pasted text, visually
nnoremap <expr> gb '`[' . strpart(getregtype(), 0, 1) . '`]'

" More natural split positioning
set splitbelow
set splitright

" Sane Searching
nnoremap / /\v
vnoremap / /\v
set ignorecase
set smartcase
set gdefault
set incsearch
set showmatch
set hlsearch

" Set up persistent undo
silent execute '!mkdir ~/.nvim/undo > /dev/null 2>&1'
set undodir=~/.nvim/undo//
set undofile
set undolevels=1000
set undoreload=10000

" Move swap and backup files into their own directory
silent execute '!mkdir ~/.nvim/backup > /dev/null 2>&1'
silent execute '!mkdir ~/.nvim/swap > /dev/null 2>&1'
set backupdir=~/.nvim/backup//
set directory=~/.nvim/swap//

" Ag
nnoremap K :Ag! "\b<C-R><C-W>\b"<CR>
vnoremap K y:Ag! "\b<C-R>"\b"<CR>
nnoremap \ :Ag<SPACE>

" The scrolloff (scroll offset) option determines the minimum number of screen
" lines that you would like above and below the cursor.
set scrolloff=3

set hidden
set visualbell
set cursorline
set colorcolumn=80
set number
set relativenumber

nnoremap <leader>f :Files<CR>
nnoremap <leader>b :Buffers<CR>

" Syntastic
let g:syntastic_php_checkers = ['php']

" Match Tag Always settings
let g:mta_filetypes = {
    \ 'html' : 1,
    \ 'xhtml' : 1,
    \ 'xml' : 1,
    \ 'jinja' : 1,
    \ 'twig' : 1,
    \}

let g:vdebug_options = {
    \ 'break_on_open': 1,
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
        \ '/var/www/xmlrpc.php' : '/Users/marc/dev/oomph/wp/xmlrpc.php'
    \}
\}

let g:gutentags_ctags_executable_php = 'ctags -R --fields=+aimS --languages=php'

" Make enter the same as C-Y in autocompletion menu
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

"let g:UltiSnipsExpandTrigger = "<nop>"
"let g:ulti_expand_or_jump_res = 0
"function ExpandSnippetOrCarriageReturn()
    "let snippet = UltiSnips#ExpandSnippetOrJump()
    "if g:ulti_expand_or_jump_res > 0
        "return snippet
    "else
        "return "\<CR>"
    "endif
"endfunction
"inoremap <expr> <CR> pumvisible() ? "<C-R>=ExpandSnippetOrCarriageReturn()<CR>" : "\<CR>"
