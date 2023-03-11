" lightweights pair function 
let s:pair_dict = {'"': '"', "'": "'", '(': ')', '[': ']', '{': '}'}
function baseconfig#PairIt(char) abort
    let l:line_text = getline('.')
    let l:col_pos = col('.')
    if index(keys(s:pair_dict), a:char) !=# -1 " if input is a left pair value
        if l:col_pos > len(l:line_text) " end of line
            return a:char . s:pair_dict[a:char] . "\<Left>"
        else
            let l:next_char = matchstr(getline('.'), '\%' . col('.') . 'c.')
            if l:next_char ==# a:char " right value is curren char
                return "\<Right>"
            elseif empty(matchstr(l:next_char, '\k'))
                return a:char . s:pair_dict[a:char] . "\<Left>"
            else
                return a:char
            endif
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

function baseconfig#Grep2Quickfix() abort
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

function baseconfig#GrepAll2Quickfix() abort
    let l:opened_buffers = s:BuffersList()
    let l:cword = expand("<cword>")
    cclose
    execute "silent! grep! " . l:cword . l:opened_buffers
    redraw!
    call clearmatches()
    silent call matchadd('Search', l:cword)
endfunction

function baseconfig#MakeDiff(...) abort
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
function baseconfig#NetrwMapping() abort
    noremap <buffer> <c-l> <c-w><c-l>
endfunction

" open buffer with order number
function baseconfig#OpenBufListed(asked_buf) abort
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

" terminal
function baseconfig#OpenTerm(is_vrt) abort
    let l:buf_term = -1
    for l:b in range(1, bufnr('$'))
        if buflisted(l:b) && nvim_buf_get_option(l:b, 'buftype') ==# 'terminal'
            let l:buf_term = l:b
            break
        endif
    endfor
    if l:buf_term ==# -1
        if a:is_vrt
            execute 'vertical split | terminal'
        else
            execute 'split | resize 15 | terminal'
        endif
        execute 'setlocal nonumber norelativenumber nocursorline nocursorcolumn signcolumn=no'
    else
        if a:is_vrt
            execute 'vertical sb ' . l:buf_term
        else
            execute 'sb ' . l:buf_term . ' | resize 15'
        endif
    endif
    normal i
endfunction

