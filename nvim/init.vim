call plug#begin('~/.local/share/nvim/plugged')

" Fugitive git functionality
Plug 'tpope/vim-fugitive'

" Show git status in the gutter
Plug 'airblade/vim-gitgutter'

" Fuzzy finder for files <leader>f,buffers <leader>b and MRU <leader>m
Plug 'ctrlpvim/ctrlp.vim'

" Extension for ctrlp to allow buffers to be closed
Plug 'd11wtq/ctrlp_bdelete.vim'

" NeoVim async version of Syntastic
Plug 'neomake/neomake'

" File browser
Plug 'scrooloose/nerdtree'

" <leader>c<space> to quickly comment current line
Plug 'scrooloose/nerdcommenter'

" Easily change somethings surroundings cs"' to change double to single quotes.
Plug 'tpope/vim-surround'

" Status bar improvments
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Allows cycling back through yanks
Plug 'vim-scripts/YankRing.vim'

" Code Completion
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }

" Multi-entry selection UI.
Plug 'junegunn/fzf'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'mhartington/nvim-typescript'
Plug 'wokalski/autocomplete-flow'
" For func argument completion
Plug 'Shougo/neosnippet'
Plug 'Shougo/neosnippet-snippets'

" <leader><leader> motion allows quick jumping to nearby file locations
Plug 'Lokaltog/vim-easymotion'

" Expand HTML
Plug 'mattn/emmet-vim'

" Show / Update files tags
Plug 'majutsushi/tagbar'

" tmux nav integration
Plug 'christoomey/vim-tmux-navigator'

" tmux focus events passed to vim
Plug 'tmux-plugins/vim-tmux-focus-events'

" Frontend HTML / JS / CSS plugins
Plug 'hail2u/vim-css3-syntax'
Plug 'pangloss/vim-javascript'

" Show CSS colours with color as background
Plug 'ap/vim-css-color'
Plug 'groenewege/vim-less'

" Typescript / Angular2 Support
Plug 'leafgarland/typescript-vim'
Plug 'Shougo/vimproc.vim', {'do' : 'make'}
Plug 'Quramy/tsuquyomi'
Plug 'jason0x43/vim-js-indent'

" Theme
Plug 'iCyMind/NeoSolarized'

call plug#end()

filetype plugin on
filetype indent on

set autoindent
set showmatch
set et

" Set tab to 2 spaces
set tabstop=2
set shiftwidth=2
set sw=2
set sts=2 " softtabstop
set backspace=2
set expandtab
set smarttab
set shiftround

" Always show the status line (0=never, 1=2+ windows, 2=always)
set laststatus=2

" Auto wrap text (comments) at 78 chars
set textwidth=80

" Warp on line breaks
set wrap linebreak

" Force diffs to wrap
autocmd FilterWritePre * if &diff | setlocal wrap< | endif

" Show spaces and line breaks
set list listchars=tab:»·,trail:·
autocmd FileType conque_term setlocal nolist 

" Switching buffers is OK with unsaved changes.
set hidden

" Show some footer info about current command
set showcmd

" Disable case sensitive searching unless search contains multiple cases
set ignorecase
set smartcase

" Jump to first matching search term
set incsearch

" Highlight all search matches
set hlsearch

" Enable vim AutoCmp menu
set wildmode=longest,list,full
set wildmenu

" Set Undo & History
set undolevels=100
set history=100

" Ignore some files
set wildignore=*.swp,*.bak,*.pyc,*.class,*.ttc

" Don't save backup files
set nobackup
set noswapfile

" Show line numbers
set number

" Remove splash screen
set shortmess+=I

set termguicolors
set background=dark
colorscheme NeoSolarized 
let g:solarized_termtrans=1 

" Set the currsor to be a rectangle in visual mode and a line in insert mode
if &term =~ '^screen'
  let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
  let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

" GENERIC VIM KEY MAPPINGS

" Change the leading char to be a backtick
let mapleader=","

" Allow saves etc with fewer key strokes ;w instead of :w
nnoremap ; :

" F5 to toggle set paste
set pastetoggle=<F5>

" Disable arrow keys to force use of hjkl, use to resize splits
nnoremap <left> :vertical resize -5<cr>
nnoremap <down> :resize +5<cr>
nnoremap <up> :resize -5<cr>
nnoremap <right> :vertical resize +5<cr>

map <PageUp> <nop>
map <PageDown> <nop>
inoremap <Left>  <nop>
inoremap <Right> <nop>
inoremap <Up>    <nop>
inoremap <Down>  <nop>
inoremap <PageUp>  <nop>
inoremap <PageDown>  <nop>

" jk move to next visible row not the next line.
nnoremap j gj
nnoremap k gk

" show registers from things cut/yanked
nmap <leader>r :registers<CR>

" map the various registers to a leader shortcut for pasting from them
nmap <leader>0 "0p
nmap <leader>1 "1p
nmap <leader>2 "2p
nmap <leader>3 "3p
nmap <leader>4 "4p
nmap <leader>5 "5p
nmap <leader>6 "6p
nmap <leader>7 "7p
nmap <leader>8 "8p
nmap <leader>9 "9p

" shortcut to toggle spelling
nmap <leader>s :setlocal spell! spelllang=en_gb<CR>

" Toggle cursor column display
nnoremap <Leader>ct :set cursorcolumn!<CR>

" shortcuts to open/close the quickfix window
nmap <leader>q :copen<CR>
nmap <leader>qc :cclose<CR>
nmap <leader>e :lopen<CR>
nmap <leader>ec :lclose<CR>
nmap <leader>en :lN<CR>
nmap <leader>ep :lN<CR>

" Save buffer with 2 keys
" If the current buffer has never been saved, it will have no name,
" call the file browser to save it, otherwise just save it.
com -nargs=0 -bar Update if &modified 
                           \|    if empty(bufname('%'))
                           \|        browse confirm write
                           \|    else
                           \|        confirm write
                           \|    endif
                           \|endif
nnoremap <silent> <C-S> :<C-u>Update<CR>
inoremap <c-s> <c-o>:Update<CR>

" for when we forget to use sudo to open/edit a file
cmap w!! w !sudo tee % >/dev/null

com! FormatJSON %!python -m json.tool
nmap =j :FormatJSON<cr>


" Map perltidy to <leader>pt
nnoremap <leader>pt :%!perltidy -q<cr> " only works in 'normal' mode
vnoremap <leader>pt :!perltidy -q<cr> " only works in 'visual' mode

vnoremap < <gv
vnoremap > >gv

" Scroll the viewport 3 lines vs just 1 line at a time
noremap <C-e> 3<C-e>
noremap <C-y> 3<C-y>

" Easy window navigation
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" <F2> close current window 
noremap <f2> <Esc>:close<CR><Esc>

" Clear current search with ,/
nmap <silent> ,/ :nohlsearch<CR>

" Map jj in insert mode to esc back to normal mode
imap jj <ESC>

" Tab options
nmap \t <Esc>:tabnew<CR>
"map ' :set hls!<bar>set hls?<CR>
nmap \n <Esc>:tabn<CR>
nmap \p <Esc>:tabp<CR>
nmap \c <Esc>:tabclose<CR>

" Space bar toggles fold or creates fold in v mode
nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR>
vnoremap <Space> zf


" PLUGIN SPECIFIC MAPPINGS AND CONFIG

let g:airline_powerline_fonts = 1

" CtrlP Settings
nnoremap <leader>f :CtrlP<CR>
" leader d to CtrlP files in the same dir as the current file
nnoremap <leader>d :CtrlP %:h<CR>
nnoremap <leader>b :CtrlPBuffer<CR>
nnoremap <leader>m :CtrlPMRUFiles<CR>
nnoremap <leader>t :CtrlPTag<CR>
let g:ctrlp_match_window = 'bottom,order:btt,min:5,max:20,results:50'
let g:ctrlp_max_files = 50000
let g:ctrlp_clear_cache_on_exit = 0
"let g:ctrlp_follow_symlinks = 1
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn)|dist|node_modules|bower_components$',
  \ 'file': '\v(\.(exe|so|dll|tar|gz|swp|bin|zip|tgz))|(-min.js|.min.js)$',
  \ 'link': '',
  \ }
call ctrlp_bdelete#init()

let g:used_javascript_libs = 'jquery,angularjs,requirejs'

" Enable deoplete at startup
let g:deoplete#enable_at_startup = 1

" Configure easy motion
let g:EasyMotion_smartcase = 1

" Better motion searhcing
map  / <Plug>(easymotion-sn)
omap / <Plug>(easymotion-tn)
map  n <Plug>(easymotion-next)
map  N <Plug>(easymotion-prev)

" 2 char searching
nmap s <Plug>(easymotion-s2)
nmap t <Plug>(easymotion-t2)

"hjkl motions
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)
map <Leader>l <Plug>(easymotion-lineforward)
map <Leader>h <Plug>(easymotion-linebackward)


" Enable fugitive
let g:statline_fugitive = 1 
" Show file paths
let g:statline_filename_relative = 1
" hide trailing space crap
let g:statline_trailing_space = 0
" hide buffer count
let g:statline_show_n_buffers = 0


" Set map to trigger zencoding defaults to C-e used above
let g:user_emmet_leader_key = '<C-y>'

" deoplete tab-complete
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
" tern
autocmd FileType javascript nnoremap <silent> <buffer> gb :TernDef<CR>

" NeoMake setup
" When writing a buffer, and on normal mode changes (after 750ms).
call neomake#configure#automake('nw', 750)
let g:neomake_open_list = 2

