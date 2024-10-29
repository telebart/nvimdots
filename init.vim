let g:loaded_ruby_provider = 0
let g:loaded_node_provider = 0
let g:loaded_perl_provider = 0
let g:loaded_python3_provider = 0

let g:loaded_gzip = 1
let g:loaded_zip = 1
let g:loaded_zipPlugin = 1
let g:loaded_tar = 1
let g:loaded_tarPlugin = 1

let g:loaded_getscript = 1
let g:loaded_getscriptPlugin = 1
let g:loaded_vimball = 1
let g:loaded_vimballPlugin = 1
" let g:loaded_2html_plugin = 1

let g:loaded_matchit = 1
let g:loaded_matchparen = 1
let g:loaded_logiPat = 1
let g:loaded_rrhelper = 1
let g:loaded_tutor_mode_plugin = 1

"let g:loaded_netrw = 1
"let g:loaded_netrwPlugin = 1
"let g:loaded_netrwSettings = 1

set shell=dash
set hls
set incsearch
set nowrap
set rnu nu
set hidden
set tabstop=2 softtabstop=2 shiftwidth=2 smartindent expandtab
exec 'set undodir=' . stdpath('data') . '/undodir'
set undofile noswapfile nobackup
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
set spr sb
set grepprg=rg\ --vimgrep
set grepformat=%f:%l:%c:%m
set nocursorline

" Netrw
let g:netrw_banner=0
let g:netrw_altv=1
let g:netrw_bufsettings = "noma nomod nu rnu nobl nowrap ro"
let g:netrw_use_errorwindow=0
let g:netrw_list_hide='^\.\+/$'

let g:mapleader=" "
let g:maplocalleader=" "

inoremap <silent> <C-e> <nop>

nnoremap <space><space> <cmd>make<CR>

nnoremap == mqHmwgg=G`wzt`q
nnoremap <silent> Q <nop>

vnoremap <silent> . :normal .<CR>

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
nnoremap G Gzz
vnoremap <leader>y "+y
nnoremap <leader>y "+y
nnoremap <leader>Y gg"+yG

nnoremap J m'J``

nnoremap yap m'yap``
nnoremap yip m'yip``
nnoremap yaw m'yaw``
nnoremap yiw m'yiw``

nnoremap <leader>yfp <cmd>let @+=expand("%:p")<CR>

" LSP
nnoremap <leader>lr <cmd>LspRestart<CR>

" QF
nnoremap <C-k> <cmd>cprev<CR>zz
nnoremap <C-j> <cmd>cnext<CR>zz
nnoremap <C-q> <cmd>call ToggleQFList()<CR>
nnoremap <leader>K <cmd>lprev<CR>zz
nnoremap <leader>J <cmd>lnext<CR>zz
nnoremap <leader>qq <cmd>call ToggleLocList()<CR>

" Git
nnoremap B <cmd>Gitsigns toggle_current_line_blame<CR>

nnoremap <leader>rr <cmd>lua Root()<CR>

nnoremap <leader>ii <cmd>set ignorecase! smartcase!<CR>

tnoremap <C-h> <C-\><C-N>

nnoremap <M-H> <C-W>h
nnoremap <M-J> <C-W>j
nnoremap <M-K> <C-W>k
nnoremap <M-L> <C-W>l

nnoremap ö :

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

vnoremap <RightMouse> <S-LeftMouse>
nnoremap <leader>pp :put=execute('')<Left><Left>
command! BufOnly execute '%bdelete|edit #|normal `"'

lua require("l.deps")
