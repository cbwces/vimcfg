" Basic comfig
filetype plugin indent on
set cursorline
set cursorcolumn
set wildmenu
set number 
set relativenumber
set linebreak
if has('nvim')
    set completeopt=menu,menuone,noselect
else
    set completeopt=menu,popup
endif
set signcolumn=yes
set laststatus=2
set lazyredraw
set foldcolumn=0
set diffopt+=foldcolumn:0
set wrap
set nowrapscan
set splitbelow
set splitright

set tabstop=4
set shiftwidth=4
set shiftround
set expandtab
set autoindent
set smartindent
set timeoutlen=1500
set ttimeoutlen=50
set updatetime=100
set noautoread
set noruler
set noshowcmd
set mouse=
set statusline=%f%=%l/%L

set noshowmode "no show status of mode
set hidden "no mention write after modify current and change to another

augroup viwer
    autocmd!
    autocmd BufRead * silent! '"
augroup END


augroup quickfix
    autocmd!
    autocmd QuickFixCmdPost [^l]* cwindow "auto add message to quickfix, openit, next line is same
    autocmd QuickFixCmdPost l* lwindow
augroup END
nnoremap [q :cp<CR>
nnoremap ]q :cn<CR>
nnoremap [Q :cfirst<CR>
nnoremap ]Q :clast<CR>

" Color scheme config
syntax on
highlight StatusLine ctermfg=239 ctermbg=Gray
highlight StatusLineNC ctermfg=239 ctermbg=Gray
highlight StatusLineTerm ctermfg=239 ctermbg=Gray
highlight StatusLineTermNC ctermfg=239 ctermbg=Gray
highlight VertSplit ctermfg=Gray ctermbg=239
highlight SignColumn cterm=none ctermbg=none
highlight LineNr ctermfg=242

highlight Folded ctermfg=gray ctermbg=none
highlight DiffAdd ctermfg=Green ctermbg=none
highlight DiffChange ctermfg=none ctermbg=none
highlight DiffDelete ctermfg=Red ctermbg=none
highlight DiffText ctermfg=Yellow ctermbg=none

highlight Search cterm=none ctermfg=Black
highlight Visual cterm=none ctermbg=LightMagenta ctermfg=Black

highlight Pmenu ctermfg=248 ctermbg=233
highlight PmenuSel ctermfg=233 ctermbg=248
highlight PmenuSbar ctermfg=233 ctermbg=none
highlight PmenuThumb ctermfg=248 ctermbg=248
highlight NormalFloat ctermfg=248 ctermbg=233

highlight CursorColumn ctermbg=238
highlight CursorLine cterm=none ctermbg=238
highlight QuickFixLine cterm=none ctermbg=none

" Keymap config
nnoremap <Space> <Nop>
let g:mapleader=" "

set incsearch
nnoremap / :set hlsearch<CR>/
nnoremap ? :set hlsearch<CR>?
nnoremap * :set hlsearch<CR>*
nnoremap # :set hlsearch<CR>#
nnoremap g* :set hlsearch<CR>g*
nnoremap g# :set hlsearch<CR>g#
vnoremap * :<C-U>set hlsearch<CR>gvy/\V<C-R>0<CR>
vnoremap # :<C-U>set hlsearch<CR>gvy?\V<C-R>0<CR>
nnoremap <silent> <Leader>hl :set hlsearch!<CR>

nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-L> <C-W>l
nnoremap <C-H> <C-W>h
if has('nvim')
    tnoremap <C-J> <C-\><C-N><C-W>j
    tnoremap <C-K> <C-\><C-N><C-W>k
    tnoremap <C-L> <C-\><C-N><C-W>l
    tnoremap <C-H> <C-\><C-N><C-W>h
    tnoremap <C-D> <C-\><C-N><C-W>c
    nnoremap <silent> <Leader>t :call baseconfig#OpenTerm(0)<CR>
    nnoremap <silent> <Leader>vt :call baseconfig#OpenTerm(1)<CR>
else
    tnoremap <C-J> <C-W>j
    tnoremap <C-K> <C-W>k
    tnoremap <C-L> <C-W>l
    tnoremap <C-H> <C-W>h
    nnoremap <silent> <Leader>t :below terminal ++rows=15<CR>
    nnoremap <silent> <Leader>vt :vertical terminal<CR>
endif

nnoremap <silent> <Leader>1 :call baseconfig#OpenBufListed(1)<CR>
nnoremap <silent> <Leader>2 :call baseconfig#OpenBufListed(2)<CR>
nnoremap <silent> <Leader>3 :call baseconfig#OpenBufListed(3)<CR>
nnoremap <silent> <Leader>4 :call baseconfig#OpenBufListed(4)<CR>
nnoremap <silent> <Leader>5 :call baseconfig#OpenBufListed(5)<CR>
nnoremap <silent> <Leader>6 :call baseconfig#OpenBufListed(6)<CR>
nnoremap <silent> <Leader>7 :call baseconfig#OpenBufListed(7)<CR>
nnoremap <silent> <Leader>8 :call baseconfig#OpenBufListed(8)<CR>
nnoremap <silent> <Leader>9 :call baseconfig#OpenBufListed(9)<CR>
nnoremap <silent> <Leader>0 :call baseconfig#OpenBufListed(10)<CR>
nnoremap <silent> <Leader>= :bn<CR>
nnoremap <silent> <Leader>- :bp<CR>

inoremap <silent><expr> ( baseconfig#PairIt('(')
inoremap <silent><expr> [ baseconfig#PairIt('[')
inoremap <silent><expr> { baseconfig#PairIt('{')
inoremap <silent><expr> ' baseconfig#PairIt("'")
inoremap <silent><expr> " baseconfig#PairIt('"')
inoremap <silent><expr> ) baseconfig#PairIt(')')
inoremap <silent><expr> ] baseconfig#PairIt(']')
inoremap <silent><expr> } baseconfig#PairIt('}')

nnoremap <S-J> jzz
nnoremap <S-K> kzz
inoremap <C-H> <C-O>^
inoremap <C-L> <C-O>$
nnoremap <Leader>gr :call baseconfig#Grep2Quickfix()<CR>
nnoremap <Leader>G :call baseconfig#GrepAll2Quickfix()<CR>
command -nargs=+ -bang Mkdiff :call s:MakeDiff(<f-args>)

augroup netrw
    autocmd!
    autocmd filetype netrw call baseconfig#NetrwMapping()
augroup END
let g:netrw_winsize=0
let g:netrw_altv=1
nnoremap <silent> <Leader>y :15Lex<CR>

" change default vim's less used keybind
nnoremap Y y$
nnoremap Q @@

" vim9
if v:version >= 900
    set wildoptions=pum
endif
