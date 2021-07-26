" For special file format code, adding flower comment block
function! LabelBlock(character, lenth, center_repeat) abort
    if !exists("b:flower_line")
	let b:flower_line=repeat(a:character, a:lenth)
	let b:center_chars=repeat(a:character, a:center_repeat)
    endif
    execute "normal! 0i".b:flower_line."\<Esc>yyp\<S-o>".b:center_chars."\<Space>"
    startinsert!
endfunction

" Show git change status on status bar
function! GitStatus() abort
    let [a, m, r] = GitGutterGetHunkSummary()
    return printf('+%d !%d -%d', a, m, r)
endfunction

" Let cursor faster return to normal window from netrw
function! NetrwMapping() abort
    noremap <buffer> <c-l> <c-w><c-l>
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
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Basic comfig
filetype plugin indent on
set cursorline
set wildmenu
set number 
set relativenumber
set linebreak
set completeopt=menu,popup
set laststatus=2
set lazyredraw

set tabstop=4
set shiftwidth=4
set shiftround
autocmd BufEnter *html setlocal tabstop=2
autocmd BufEnter *html setlocal shiftwidth=2
set expandtab
set autoindent

set noshowmode "no show status of mode
set hidden "no mention write after modify current and change to another
set timeoutlen=3000
set ttimeoutlen=100

autocmd BufRead * normal zR
autocmd BufWrite * mkview
autocmd BufRead * silent! loadview

autocmd QuickFixCmdPost [^l]* cwindow "auto add message to quickfix, openit, next line is same
autocmd QuickFixCmdPost l* lwindow
noremap [q :cp<CR>
noremap ]q :cn<CR>

" Color scheme config
syntax on
highlight SignColumn cterm=none ctermbg=none
highlight Search cterm=none ctermfg=Black
highlight Visual cterm=none ctermbg=Yellow ctermfg=Black
highlight Pmenu ctermfg=Black ctermbg=187
highlight PmenuSel ctermfg=White ctermbg=Black

" Keymap config
nnoremap <Space> <Nop>
let g:mapleader=" "

nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-L> <C-W>l
nnoremap <C-H> <C-W>h
nnoremap <C-D> <C-W>c
tnoremap <C-J> <C-W>j
tnoremap <C-K> <C-W>k
tnoremap <C-L> <C-W>l
tnoremap <C-H> <C-W>h

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

nnoremap <silent> <Leader>t :below terminal<CR><C-W>5-
nnoremap <silent> <Leader>vt :vertical terminal<CR>

autocmd filetype python nnoremap <buffer> <Leader>i :call LabelBlock('#', 50, 1)<CR>
autocmd filetype cpp nnoremap <buffer> <Leader>i :call LabelBlock('/', 50, 0)<CR>
autocmd filetype c nnoremap <buffer> <Leader>i :call LabelBlock('/', 50, 0)<CR>
autocmd filetype cuda nnoremap <buffer> <Leader>i :call LabelBlock('/', 50, 0)<CR>

autocmd filetype netrw call NetrwMapping()
let g:netrw_winsize=0
let g:netrw_altv=1
nnoremap <silent> <Leader>y :Lex<CR>:vertical resize 20<CR>

" custom-text-obj
onoremap <silent> id :<C-u>normal! T/vt/<CR>
onoremap <silent> ad :<C-u>normal! F/vf/<CR>
xnoremap <silent> id :<C-U>normal! T/vt/<CR>
xnoremap <silent> ad :<C-U>normal! F/vf/<CR>

" vista
autocmd filetype c let g:vista_default_executive="ale"
autocmd filetype cpp let g:vista_default_executive="ale"
nnoremap <silent> <Leader>u :Vista!!<CR>

" ale
"let g:ale_set_highlights=0
"let g:ale_warn_about_trailing_blank_lines=0
"let g:ale_warn_about_trailing_whitespace=0
"let g:ale_sign_error='!'
"let g:ale_sign_warning='*'
"nnoremap <silent> <Leader>j :ALENext -wrap -error<CR>
"nnoremap <silent> <Leader><S-j> :ALEPrevious -wrap -error<CR>
"highlight ALEWarningSign cterm=none ctermbg=none ctermfg=Yellow
"highlight ALEErrorSign cterm=none ctermbg=none ctermfg=Red

" coc
set signcolumn=yes
nmap <silent> [g <Plug>(coc-diagnostic-prev-error)
nmap <silent> ]g <Plug>(coc-diagnostic-next-error)
nmap <silent> <leader>dd <Plug>(coc-definition)
nmap <silent> <leader>dt <Plug>(coc-type-definition)
nmap <silent> <leader>di <Plug>(coc-implementation)
nmap <silent> <leader>dr <Plug>(coc-references)
nnoremap <silent> <leader>k :call <SID>show_documentation()<CR>
nmap <leader>rn <Plug>(coc-rename)
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)
nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
highlight CocWarningSign ctermfg=green
highlight CocInfoSign ctermfg=cyan
highlight CocErrorSign ctermfg=red
inoremap <silent> <C-j> <C-o>:call coc#float#close_all()<CR>
nnoremap <silent> <space>j :call coc#float#close_all()<CR>

" nerdcomment
let g:NERDDefaultNesting=0
nnoremap <silent> <C-m> :call NERDComment(0, "toggle")<CR>
vnoremap <silent> <C-m> :call NERDComment(0, "toggle")<CR>
nmap <silent> + <Space>cA

" quickscope
highlight QuickScopePrimary cterm=none ctermfg=DarkBlue
highlight QuickScopeSecondary cterm=none ctermfg=Red

" sneak
let g:sneak#label=1

" buftabline
let g:buftabline_show=1
let g:buftabline_numbers=1
let g:buftabline_indicators=1

" incsearch
set hlsearch
let g:incsearch#auto_nohlsearch=1
let g:incsearch#do_not_save_error_message_history=1
map n  <Plug>(incsearch-nohl-n)
map N  <Plug>(incsearch-nohl-N)
map *  <Plug>(incsearch-nohl-*)
map #  <Plug>(incsearch-nohl-#)
map g* <Plug>(incsearch-nohl-g*)
map g# <Plug>(incsearch-nohl-g#)
map / <Plug>(incsearch-forward)
map ? <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)

" markdown show plugin
autocmd filetype markdown nmap <buffer> <silent> <Leader> ysiW*lysiW*l
autocmd filetype markdown nmap <buffer> <silent> <Leader>B ds*ds*
autocmd filetype markdown setlocal conceallevel=2

" gitgutter
set updatetime=1000
set statusline=%f\ %=%{GitStatus()}\ r%l\ c%c\ t%L
highlight GitGutterAdd cterm=none ctermfg=Blue ctermbg=none
highlight GitGutterChange cterm=none ctermfg=Blue ctermbg=none
highlight GitGutterDelete cterm=none ctermfg=Blue ctermbg=none

" MRU
nnoremap <silent> <Leader><Leader> :MRU<CR>

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

" how-much
let g:HowMuch_scale = 5
let g:HowMuch_auto_engines = ['py', 'vim', 'bc']

" rainbow
let g:rainbow_active = 1

"for ycm enable
"function SetYcmPython() abort
    "nnoremap <buffer> <Leader>dd :YcmComple GoTo<CR>
    "nnoremap <buffer> <Leader>gt :YcmComple GetType<CR>
    "nnoremap <buffer> <Leader>kk :YcmComple GetDoc<CR>
    "nnoremap <buffer> <Leader>rr :YcmComple RefactorRename 
"endfunction
"function SetYcmC() abort
    "nnoremap <buffer> <Leader>di :YcmComple GoToInclude<CR>
    "nnoremap <buffer> <Leader>dc :YcmComple GoToDeclaration<CR>
    "nnoremap <buffer> <Leader>df :YcmComple GoToDefinition<CR>
    "nnoremap <buffer> <Leader>gt :YcmComple GetType<CR>
    "nnoremap <buffer> <Leader>kk :YcmComple GetDoc<CR>
    "nnoremap <buffer> <Leader>rr :YcmComple RefactorRename 
"endfunction
"let g:ycm_key_invoke_completion = '<Leader><Tab>'
"let g:ycm_use_ultisnips_completer=0
"let g:ycm_show_diagnostics_ui=0
"let g:ycm_auto_hover=''
"autocmd filetype python call SetYcmPython()
"autocmd filetype cpp call SetYcmC()
"autocmd filetype c call SetYcmC()
"autocmd filetype cuda call SetYcmC()
