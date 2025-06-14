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
set completeopt=menuone,noselect,fuzzy
set list listchars=tab:▸\ ,trail:·
set nofixendofline
set cpoptions+=>
set termguicolors
set splitkeep=screen
set spell
set spelloptions=camel,noplainbuffer
set laststatus=2
set wildignore+=**/node_modules/**
set spr sb
set grepprg=rg\ --vimgrep
set grepformat=%f:%l:%c:%m
set nocursorline
set diffopt+="algorithm:histogram"
set winborder=rounded

lua require("l.colors")()

" Netrw
let g:netrw_banner=0
let g:netrw_altv=1
let g:netrw_bufsettings = "noma nomod nu rnu nobl nowrap ro"
let g:netrw_use_errorwindow=0
let g:netrw_list_hide='^\.\+/$'

let g:mapleader=" "
let g:maplocalleader=" "

inoremap <silent> <C-e> <nop>
nnoremap <nowait> gr gr

nnoremap <space><space> <cmd>make<CR>

nnoremap == mqHmwgg=G`wzt`q
nnoremap <silent> Q <nop>

vnoremap <silent> . :normal .<CR>

nnoremap <leader>u :UndotreeToggle<CR>
nnoremap <leader>s :%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>

nnoremap <leader>tt <cmd>lua require("l.colors")()<CR>

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

nnoremap <leader>YFP <cmd>let @+=expand("%")<CR>

" LSP
nnoremap <leader>lr <cmd>LspRestart<CR>
nnoremap <leader>li <cmd>LspInfo<CR>

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
nnoremap <leader>rl <cmd>lua Root(true)<CR>

nnoremap <leader>ii <cmd>set ignorecase! smartcase!<CR>

tnoremap <C-h> <C-\><C-N>

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

lua require("l.statusline")
lua require("l.deps")

augroup yank_restore_cursor
  autocmd!
  autocmd VimEnter,CursorMoved *
        \ let s:cursor = getpos('.')
  autocmd TextYankPost *
        \ if v:event.operator ==? 'y' |
        \ call setpos('.', s:cursor) |
        \ endif
augroup END
