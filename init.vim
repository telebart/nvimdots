set nohls
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
set shortmess+=c
set signcolumn=yes
set mouse=a
set completeopt=menu,menuone,noselect
set list listchars=tab:▸\ ,trail:·
set autowrite
set autoread
set nofixendofline
set cpoptions+=>

set laststatus=2

lua require("l.plugins")

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

" nnoremap <leader>pv <cmd>Ex<CR>

" LSP
nnoremap <leader>lr <cmd>LspRestart<CR>

" Telescope
nnoremap <leader>ps <cmd>lua require('telescope.builtin').grep_string({ search = vim.fn.input("Grep For > ")})<CR>
nnoremap <leader>pa <cmd>lua require('telescope.builtin').live_grep()<CR>
nnoremap <C-p> <cmd>lua require('telescope.builtin').git_files({show_untracked=true})<CR>
nnoremap <Leader>pf <cmd>lua require'telescope.builtin'.find_files()<CR>
nnoremap <leader>pw <cmd>lua require'telescope.builtin'.grep_string()<CR>
nnoremap <leader>pb <cmd>lua require'telescope.builtin'.buffers()<CR>
nnoremap <leader>fh <cmd>lua require'telescope.builtin'.help_tags()<CR>
nnoremap <leader>fp <cmd>lua require'telescope.builtin'.git_bcommits()<CR>
nnoremap <leader>gs <cmd>lua require'telescope.builtin'.git_status()<CR>
nnoremap <leader>gh <cmd>lua require'telescope.builtin'.git_branches()<CR>

" QF
nnoremap <C-k> <cmd>cprev<CR>zz
nnoremap <C-j> <cmd>cnext<CR>zz
nnoremap <leader>k <cmd>lprev<CR>zz
nnoremap <leader>j <cmd>lnext<CR>zz
nnoremap <C-q> <cmd>call ToggleQFList()<CR>
nnoremap <leader>qq <cmd>call ToggleLocList()<CR>

" Git
nnoremap B <cmd>Gitsigns blame_line<CR>

" Go
nnoremap <leader>ie <cmd>GoIfErr<CR>

" Rooter
let g:rooter_manual_only = 1
nnoremap <leader>jf <cmd>Rooter<CR>

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
