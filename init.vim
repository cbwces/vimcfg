" Show git status on status bar
function! GitStatus() abort
    let git_status = GitGutterGetHunkSummary()
    if git_status ==# [0, 0, 0]
        return printf(gitbranch#name())
    else
        return printf('+%s', gitbranch#name())
    endif
endfunction

" coc show doc
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" coc tab deal with popup
function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
endfunction

function! ScrollMap(is_down) abort
    if coc#float#has_scroll()
        return coc#float#scroll(a:is_down)
    elseif len(popup_list())
        return a:is_down ? ":call gtrans#Scroll(g:popup_trans_obj, 1)\<CR>" : ":call gtrans#Scroll(g:popup_trans_obj, 0)\<CR>"
    else
        return a:is_down ? "\<C-f>" : "\<C-b>"
    endif
endfunction

function! s:get_visual_selection() abort range
    let l:column_start = col("'<")
    let l:column_end = col("'>")
    let l:lines = getline(a:firstline, a:lastline)
    if len(l:lines) ==# 0
        return ''
    endif
    let l:lines[-1] = l:lines[-1][:l:column_end - (&selection ==# 'inclusive' ? 1 : 2)]
    let l:lines[0] = l:lines[0][l:column_start - 1:]
    return join(l:lines, "\n")
endfunction

let g:python3_host_prog='/usr/bin/python'

" vista
let g:vista_executive_for = {
            \ 'cpp': 'coc',
            \ 'c': 'coc',
            \ 'python': 'coc',
            \ 'javascript': 'coc'
            \}
nnoremap <silent> <Space>u :Vista!!<CR>

" nerdcomment
let g:NERDDefaultNesting=0
nnoremap <silent> <C-n> :call nerdcommenter#Comment(0, "toggle")<CR>
vnoremap <silent> <C-n> :call nerdcommenter#Comment(0, "toggle")<CR>
nmap <silent> + <Space>cA

" quickscope
highlight QuickScopePrimary cterm=none ctermfg=DarkBlue
highlight QuickScopeSecondary cterm=none ctermfg=Red

" easy motion
let g:EasyMotion_do_mapping=0
let g:EasyMotion_smartcase=1
nmap s <Plug>(easymotion-s2)
nmap S <Plug>(easymotion-overwin-f2)

" buftabline
let g:buftabline_show=1
let g:buftabline_numbers=1
let g:buftabline_indicators=1
highlight TabLineSel ctermfg=Gray ctermbg=Black
highlight TabLine ctermfg=Gray ctermbg=239
highlight TabLineFill ctermfg=239 ctermbg=Gray

" gitgutter
set updatetime=100
set statusline=%f\ %=%{GitStatus()}\ %L
highlight GitGutterAdd cterm=none ctermfg=Blue ctermbg=none
highlight GitGutterChange cterm=none ctermfg=Blue ctermbg=none
highlight GitGutterDelete cterm=none ctermfg=Blue ctermbg=none

" coc
set signcolumn=yes
nmap <silnt> [g <Plug>(coc-diagnostic-prev-error)
nmap <silent> ]g <Plug>(coc-diagnostic-next-error)
nmap <silent> <space>dd <Plug>(coc-definition)
nmap <silent> <space>dt <Plug>(coc-type-definition)
nmap <silent> <space>di <Plug>(coc-implementation)
nmap <silent> <space>dr <Plug>(coc-references)
nnoremap <silent> <space>k :call <SID>show_documentation()<CR>
nmap <space>rn <Plug>(coc-rename)
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
highlight CocInfoSign ctermfg=cyan
highlight CocWarningSign ctermfg=green
highlight CocErrorSign ctermfg=red
highlight CocMenuSel ctermfg=white ctermbg=239
highlight link CocHintHighlight NONE
highlight link CocInfoHighlight NONE
highlight link CocWarningHighlight NONE
highlight link CocErrorHighlight NlNE
inoremap <silent> <C-j> <C-o>:call coc#float#close_all()<CR>
nnoremap <silent> <space>j :call coc#float#close_all()<CR>

" MRU
nnoremap <silent> <Space><Space> :MRUToggle<CR>

" pear-tree
let g:pear_tree_smart_openers=1
let g:pear_tree_smart_closers=1
let g:pear_tree_smart_backspace=1

" header
let g:header_auto_add_header=0
let g:header_field_filename=0
let g:header_field_author='cbwces'
let g:header_field_author_email='sknyqbcbw@gmail.com'
let g:header_field_modified_timestamp=0
let g:header_field_modified_by=0
let g:header_field_timestamp_format='%Y%m%d'

" rainbow
let g:rainbow_active = 1

" cursorword
let g:cursorword_insert = 0

" nvim
if has('nvim')
    autocmd TextYankPost * silent! lua vim.highlight.on_yank ({higroup="IncSearch", timeout=200})
    let g:MRU_File = $HOME . '/.local/share/nvim/.vim_mru_files'
endif
