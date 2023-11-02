let g:loaded_ruby_provider = 0
let g:loaded_node_provider = 0
let g:loaded_perl_provider = 0
let g:loaded_python3_provider = 0

set hls
set incsearch
set nowrap
set rnu nu
set hidden
set tabstop=2 softtabstop=2
set shiftwidth=2
set expandtab
set smartindent
set noswapfile
set nobackup
exec 'set undodir=' . stdpath('data') . '/undodir'
set undofile
set scrolloff=8 sidescrolloff=12
set cmdheight=1
set updatetime=50
set shortmess+=WcC
set signcolumn=yes
set mouse=a
set completeopt=menu,menuone,noselect
set list listchars=tab:▸\ ,trail:·
set nofixendofline
set cpoptions+=>
set termguicolors
set splitkeep="screen"
set spell
set spelloptions=camel,noplainbuffer
set laststatus=2
set path+=**
set wildignore+=**/node_modules/**
set wildignore+=**/vendor/**

" Netrw
let g:netrw_banner=0
let g:netrw_altv=1
let g:netrw_bufsettings = "noma nomod nu rnu nobl nowrap ro"
let g:netrw_use_errorwindow=0

lua require("l.lazy")

nnoremap <space><space> <cmd>make<CR>

nnoremap <silent> Q <nop>

vnoremap <silent> . :normal .<CR>

nnoremap <silent> <C-s> <cmd>w<CR>
vnoremap <silent> <C-s> <cmd>w<CR>
inoremap <silent> <C-s> <cmd>w<CR>

nnoremap <leader>u :UndotreeToggle<CR>
nnoremap <leader>s :%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>

nnoremap <leader>tt <cmd>set expandtab!<CR>

nnoremap H ^
nnoremap L g_
vnoremap H ^
vnoremap L g_
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
vnoremap <leader>y "+y
nnoremap <leader>y "+y
nnoremap <leader>Y gg"+yG

nnoremap J m'J``

nnoremap yap m'yap``
nnoremap yip m'yip``
nnoremap yaw m'yaw``
nnoremap yiw m'yiw``

nnoremap yfp <cmd>let @+=expand("%:p")<CR>

nnoremap <leader>pv <cmd>Ex<CR>

" LSP
nnoremap <leader>lr <cmd>LspRestart<CR>

" QF
nnoremap <C-k> <cmd>cprev<CR>zz
nnoremap <C-j> <cmd>cnext<CR>zz
nnoremap <leader>k <cmd>lprev<CR>zz
nnoremap <leader>j <cmd>lnext<CR>zz
nnoremap <C-q> <cmd>call ToggleQFList()<CR>
nnoremap <leader>qq <cmd>call ToggleLocList()<CR>

" Git
nnoremap B <cmd>Gitsigns toggle_current_line_blame<CR>

" Go
nnoremap <leader>ie <cmd>GoIfErr<CR>

nnoremap <leader>jf <cmd>lua Root()<CR>

nnoremap <leader>ii <cmd>set ignorecase! smartcase!<CR>

tnoremap <leader><Esc> <C-\><C-N>

fun! ToggleQFList()
    if empty(filter(getwininfo(), 'v:val.quickfix'))
        copen
    else
        cclose
    endif
endfun

fun! ToggleLocList()
    if empty(filter(getwininfo(), 'v:val.loclist'))
        lopen
    else
        lclose
    endif
endfun

lua require("l.globals")
lua require("l.treesitter")
lua require("l.filetypes")

colorscheme rose-pine

vnoremap <RightMouse> <S-LeftMouse>
