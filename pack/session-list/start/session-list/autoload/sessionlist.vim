highlight default link SessionList Label
let s:session_dir = get(g:, 'session_save_dir', $HOME . '/.local/share/nvim/session/')
let s:session_dir = s:session_dir[len(s:session_dir)-1] ==# '/' ? s:session_dir : s:session_dir . '/'
let s:session_file = get(g:, 'session_list_record_file', $HOME . '/.local/share/nvim/session/list.json')
let s:session_window_name = '-SessionList-'
let s:session_list_buf = -1
let s:session_list_win = -1
let s:namespace = nvim_create_namespace('session_list')
let s:ext_id_list = []
if !isdirectory(s:session_dir) | call mkdir(s:session_dir, 'p') | endif
let s:source_mapping_key = get(g:, 'session_list_source_mapping_key', '<space>p')
let s:delete_mapping_key = get(g:, 'session_list_delete_map_key', '<space>d')
let s:rename_mapping_key = get(g:, 'session_list_rename_map_key', '<space>r')
let s:overwrite_mapping_key = get(g:, 'session_list_overwrite_map_key', '<space>w')

function! s:PutVirText(lines) abort
    let s:ext_id_list = []
    for l:i in range(len(a:lines))
        let l:opts = #{virt_text: [[a:lines[l:i], 'SessionList']], virt_text_pos: 'right_align', hl_mode: 'combine'}
        let l:ext_id = nvim_buf_set_extmark(0, s:namespace, l:i, 0, l:opts)
        call add(s:ext_id_list, l:ext_id)
    endfor
endfunction

function! s:ClearVirText() abort
    for l:ext_id in s:ext_id_list
        call nvim_buf_del_extmark(0, s:namespace, l:ext_id)
    endfor
endfunction

function! s:RemoveVirText(line_nr) abort
    call nvim_buf_del_extmark(0, s:namespace, s:ext_id_list[a:line_nr-1])
    unlet s:ext_id_list[a:line_nr-1]
endfunction

function! s:FreshWindow() abort
    if filereadable(s:session_file)
        let l:session_file_json = json_decode(readfile(s:session_file))
    else
        let l:session_file_json = {}
    endif
    setlocal buftype=nofile
    setlocal bufhidden=delete
    setlocal noswapfile
    setlocal nobuflisted
    setlocal nowrap
    setlocal foldcolumn=0
    setlocal modifiable
    call s:ClearVirText()
    normal ggdG
    put =keys(l:session_file_json)
    normal ggdd
    call s:PutVirText(values(l:session_file_json))
    setlocal nomodifiable
    execute "nnoremap <silent><nowait><buffer> " . s:source_mapping_key . " :call <SID>SourceSession()<CR>"
    execute "nnoremap <silent><nowait><buffer> " . s:delete_mapping_key . " :call <SID>DeleteSession()<CR>"
    execute "nnoremap <silent><nowait><buffer> " . s:rename_mapping_key . " :call <SID>RenameSession()<CR>"
    execute "nnoremap <silent><nowait><buffer> " . s:overwrite_mapping_key . " :call <SID>OverWriteSession()<CR>"
endfunction

function! s:SourceSession() abort
    let s:session_list_buf = -1
    let s:session_list_win = -1
    let l:line = getline('.')
    let l:save_path = s:session_dir . l:line
    execute 'source ' . l:save_path
endfunction

function! s:DeleteSession() abort
    let l:line = getline('.')
    if len(l:line) !=# 0
        let l:choice = confirm("Delete Session?", "&Yes\n&No", 2)
        if l:choice == 1
            let l:save_path = s:session_dir . l:line
            let l:del_status = delete(l:save_path)
            if l:del_status ==# 0
                setlocal modifiable
                call s:RemoveVirText(line('.'))
                normal dd
                setlocal nomodifiable
                let l:session_file_json = json_decode(readfile(s:session_file))
                unlet l:session_file_json[l:line]
                call writefile([json_encode(l:session_file_json)], s:session_file)
            else
                echoerr 'Can not delete file ' . l:save_path
            endif
        endif
    endif
endfunction

function! s:RenameSession() abort
    let l:line = getline('.')
    if len(l:line) !=# 0
        let l:new_name = input('New Name:')
        if !empty(l:new_name)
            setlocal modifiable
            execute "normal 0C" . l:new_name
            setlocal nomodifiable
            let l:session_file_json = json_decode(readfile(s:session_file))
            let l:new_session_file_json = {}
            for [l:key, l:val] in items(l:session_file_json)
                if l:key !=# l:line
                    let l:new_session_file_json[l:key] = l:val
                else
                    let l:new_session_file_json[l:new_name] = l:val
                endif
            endfor
            call writefile([json_encode(l:new_session_file_json)], s:session_file)
            let l:old_path = s:session_dir . l:line
            let l:new_path = s:session_dir . l:new_name
            call rename(l:old_path, l:new_path)
        endif
    endif
endfunction

function! s:OverWriteSession() abort
    let l:line = getline('.')
    if len(l:line) !=# 0
        let l:save_path = s:session_dir . l:line
        let l:bufhidden = &bufhidden
        set bufhidden=wipe
        execute 'bd! ' . s:session_list_buf
        let &bufhidden = l:bufhidden
        let s:session_list_buf = -1
        let s:session_list_win = -1
        execute 'mksession! ' . l:save_path
    endif
endfunction

function! sessionlist#LoadSession() abort
    if s:session_list_buf ==# -1
        vnew | vertical resize 50
        execute 'edit ' . s:session_window_name
        let s:session_list_buf = bufnr()
        let s:session_list_win = win_getid()
        call s:FreshWindow()
    elseif win_findbuf(s:session_list_buf) ==# []
        execute 'vertical sb ' . s:session_list_buf . ' | vertical resize 50'
        let s:session_list_win = win_getid()
        call s:FreshWindow()
    else
        call win_gotoid(s:session_list_win)
    endif
endfunction

function! sessionlist#SaveSession(bang, ...) abort
    let l:save_path = s:session_dir . a:1
    let l:session_virtext = join(a:000[1:], ' ')
    if filereadable(s:session_file)
        let l:session_file_json = json_decode(readfile(s:session_file))
    else
        let l:session_file_json = {}
    endif
    if win_findbuf(s:session_list_buf) !=# []
        let l:bufhidden = &bufhidden
        set bufhidden=wipe
        execute 'bd! ' . s:session_list_buf
        let &bufhidden = l:bufhidden
        let s:session_list_buf = -1
        let s:session_list_win = -1
    endif
    if a:bang
        execute 'mksession! ' . l:save_path
    else
        execute 'mksession ' . l:save_path
    endif
    let l:session_file_json[a:1] = l:session_virtext
    call writefile([json_encode(l:session_file_json)], s:session_file)
endfunction
