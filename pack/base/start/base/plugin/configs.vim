" Add word under cursor to quickfix and highlight it
function! Grep2Quickfix() abort
    let l:cword = expand("<cword>")
    cclose
    silent! grep! <cword> %
    redraw!
    call clearmatches()
    silent call matchadd('Search', l:cword)
endfunction

function! s:BuffersList() abort
    let l:opened_buffers = ''
    for l:b in range(1, bufnr('$'))
        if buflisted(l:b)
            let opened_buffers = opened_buffers . ' ' . bufname(l:b)
        endif
    endfor
    return l:opened_buffers
endfunction

function! GrepAll2Quickfix() abort
    let l:opened_buffers = s:BuffersList()
    let l:cword = expand("<cword>")
    cclose
    execute "silent! grep! " . l:cword . l:opened_buffers
    redraw!
    call clearmatches()
    silent call matchadd('Search', l:cword)
endfunction

" Let cursor faster return to normal window from netrw
function! NetrwMapping() abort
    noremap <buffer> <c-l> <c-w><c-l>
endfunction

" Basic comfig
filetype plugin indent on
set cursorline
set cursorcolumn
set wildmenu
set number 
set relativenumber
set linebreak
if has('nvim')
    set completeopt=menu,preview
else
    set completeopt=menu,popup
endif
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
set timeoutlen=2000
set ttimeoutlen=100
set noautoread

set noshowmode "no show status of mode
set hidden "no mention write after modify current and change to another

augroup viwer
    autocmd!
    autocmd BufRead * normal zR
    autocmd BufWrite * mkview
    autocmd BufRead * silent! loadview
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
highlight VertSplit ctermfg=239 ctermbg=Gray
highlight Folded ctermfg=gray ctermbg=none
highlight DiffAdd ctermfg=Green ctermbg=none
highlight DiffChange ctermfg=none ctermbg=none
highlight DiffDelete ctermfg=Red ctermbg=none
highlight DiffText ctermfg=Yellow ctermbg=none
highlight SignColumn cterm=none ctermbg=none
highlight Search cterm=none ctermfg=Black
highlight Visual cterm=none ctermbg=LightMagenta ctermfg=Black
highlight Pmenu ctermfg=Black ctermbg=187
highlight PmenuSel ctermfg=Gray ctermbg=Black
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
else
    tnoremap <C-J> <C-W>j
    tnoremap <C-K> <C-W>k
    tnoremap <C-L> <C-W>l
    tnoremap <C-H> <C-W>h
endif

nnoremap <silent> <Leader>1 :b1<CR>
nnoremap <silent> <Leader>2 :b2<CR>
nnoremap <silent> <Leader>3 :b3<CR>
nnoremap <silent> <Leader>4 :b4<CR>
nnoremap <silent> <Leader>5 :b5<CR>
nnoremap <silent> <Leader>6 :b6<CR>
nnoremap <silent> <Leader>7 :b7<CR>
nnoremap <silent> <Leader>8 :b8<CR>
nnoremap <silent> <Leader>9 :b9<CR>
nnoremap <silent> <Leader>0 :b10<CR>
nnoremap <silent> <Leader>= :bn<CR>
nnoremap <silent> <Leader>- :bp<CR>

nnoremap <S-J> jzz
nnoremap <S-K> kzz
inoremap <C-H> <C-O>^
inoremap <C-L> <C-O>$
nnoremap <Leader>gr :call Grep2Quickfix()<CR>
nnoremap <Leader>G :call GrepAll2Quickfix()<CR>

if has('nvim')
    nnoremap <silent> <Leader>t :split<bar>resize 15<bar>terminal<CR>:set nonumber norelativenumber nocursorline nocursorcolumn<CR>i
    nnoremap <silent> <Leader>vt :vertical split<bar>terminal<CR>:set nonumber norelativenumber nocursorline nocursorcolumn<CR>i
else
    nnoremap <silent> <Leader>t :below terminal ++rows=15<CR>
    nnoremap <silent> <Leader>vt :vertical terminal<CR>
endif

augroup netrw
    autocmd!
    autocmd filetype netrw call NetrwMapping()
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
