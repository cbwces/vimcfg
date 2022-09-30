" lightweights pair function
let s:pair_dict = {'"': '"', "'": "'", '(': ')', '[': ']', '{': '}'}
function s:PairIt(char) abort
    let l:line_text = getline('.')
    let l:col_pos = col('.')
    if index(keys(s:pair_dict), a:char) !=# -1 " if input is a left pair value
        if l:col_pos > len(l:line_text)
            return a:char . s:pair_dict[a:char] . "\<Left>"
        elseif matchstr(getline('.'), '\%' . col('.') . 'c.') !=# a:char
            return a:char . s:pair_dict[a:char] . "\<Left>"
        else
            return "\<Right>"
        endif
    elseif index(values(s:pair_dict), a:char) !=# -1 " if input is a right pair value
        if l:col_pos > len(l:line_text)
            return a:char
        elseif matchstr(getline('.'), '\%' . col('.') . 'c.') ==# a:char
            return "\<Right>"
        else
            return a:char
        endif
    else
        return a:char
    endif
endfunction

" Add word under cursor to quickfix and highlight it
function Grep2Quickfix() abort
    let l:cword = expand("<cword>")
    cclose
    silent! grep! <cword> %
    redraw!
    call clearmatches()
    silent call matchadd('Search', l:cword)
endfunction

function s:BuffersList() abort
	let l:opened_buffers = filter(range(1, bufnr('$')), 'buflisted(v:val)')
    return join(l:opened_buffers, ' ')
endfunction

function GrepAll2Quickfix() abort
    let l:opened_buffers = s:BuffersList()
    let l:cword = expand("<cword>")
    cclose
    execute "silent! grep! " . l:cword . l:opened_buffers
    redraw!
    call clearmatches()
    silent call matchadd('Search', l:cword)
endfunction

function s:MakeDiff(...) abort
    let l:ft = &filetype
    new
    execute "edit diff1_" . a:1
    only
    silent! execute "0put " . a:1
    let l:n = 1
    for diff_reg in a:000[1:]
        let l:n += 1
        vnew
        execute "edit diff" . l:n . "_" . diff_reg
        silent! execute "0put " . diff_reg
    endfor
    windo diffthis
endfunction

" Let cursor faster return to normal window from netrw
function NetrwMapping() abort
    noremap <buffer> <c-l> <c-w><c-l>
endfunction

" open buffer with order number
function OpenBufListed(asked_buf) abort
    let l:buf_order_number = 1
    for l:b in range(1, bufnr('$'))
        if buflisted(l:b)
            if l:buf_order_number ==# a:asked_buf
                break
            endif
            let l:buf_order_number += 1
        endif
    endfor
    execute "b" . l:b
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
set noautoread
set noruler
set noshowcmd

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
    nnoremap <silent> <Leader>t :split<bar>resize 15<bar>terminal<CR>:setlocal nonumber norelativenumber nocursorline nocursorcolumn<CR>i
    nnoremap <silent> <Leader>vt :vertical split<bar>terminal<CR>:setlocal nonumber norelativenumber nocursorline nocursorcolumn<CR>i
else
    tnoremap <C-J> <C-W>j
    tnoremap <C-K> <C-W>k
    tnoremap <C-L> <C-W>l
    tnoremap <C-H> <C-W>h
    nnoremap <silent> <Leader>t :below terminal ++rows=15<CR>
    nnoremap <silent> <Leader>vt :vertical terminal<CR>
endif

nnoremap <silent> <Leader>1 :call OpenBufListed(1)<CR>
nnoremap <silent> <Leader>2 :call OpenBufListed(2)<CR>
nnoremap <silent> <Leader>3 :call OpenBufListed(3)<CR>
nnoremap <silent> <Leader>4 :call OpenBufListed(4)<CR>
nnoremap <silent> <Leader>5 :call OpenBufListed(5)<CR>
nnoremap <silent> <Leader>6 :call OpenBufListed(6)<CR>
nnoremap <silent> <Leader>7 :call OpenBufListed(7)<CR>
nnoremap <silent> <Leader>8 :call OpenBufListed(8)<CR>
nnoremap <silent> <Leader>9 :call OpenBufListed(9)<CR>
nnoremap <silent> <Leader>0 :call OpenBufListed(10)<CR>
nnoremap <silent> <Leader>= :bn<CR>
nnoremap <silent> <Leader>- :bp<CR>

inoremap <silent><expr> ( <SID>PairIt('(')
inoremap <silent><expr> [ <SID>PairIt('[')
inoremap <silent><expr> { <SID>PairIt('{')
inoremap <silent><expr> ' <SID>PairIt("'")
inoremap <silent><expr> " <SID>PairIt('"')
inoremap <silent><expr> ) <SID>PairIt(')')
inoremap <silent><expr> ] <SID>PairIt(']')
inoremap <silent><expr> } <SID>PairIt('}')

nnoremap <S-J> jzz
nnoremap <S-K> kzz
inoremap <C-H> <C-O>^
inoremap <C-L> <C-O>$
nnoremap <Leader>gr :call Grep2Quickfix()<CR>
nnoremap <Leader>G :call GrepAll2Quickfix()<CR>
command -nargs=+ -bang Mkdiff :call s:MakeDiff(<f-args>)

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
