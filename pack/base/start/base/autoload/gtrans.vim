" Author: cbwces <sknyqbcbw@gmail.com>
" Date  : 20220831

let g:gtrans_aim_language = 'zh'
let g:gtrans_dict_path = $HOME . "/.vim/translatedict.txt"

function! gtrans#TransThis(word) abort
    let g:pop_trans_list = []
    let l:job = job_start(['trans', '--no-ansi',':' . tolower(g:gtrans_aim_language), a:word], {'callback': "<SID>TransHandler", 'exit_cb': "<SID>PopTrans"})
endfunction

function! s:TransHandler(channel, result) abort
    let g:pop_trans_list = add(g:pop_trans_list, a:result)
endfunction

function! s:PopTrans(channel, result) abort
    let g:pop_trans_list_length = len(g:pop_trans_list)
    call popup_clear()
    if g:pop_trans_list_length > 1
        let g:popup_trans_obj = popup_atcursor(g:pop_trans_list, {'moved': 'word', 'padding': [0, 1, 0, 1]})
    else
        let g:popup_trans_obj = popup_atcursor("!! No Translate Result !!", {'moved': 'word', 'highlight': 'ErrorMsg'})
    endif
endfunction

function! gtrans#Scroll(popup_obj_id, is_down) abort
    let l:popup_info = popup_getpos(a:popup_obj_id)
    if l:popup_info['scrollbar']
        if a:is_down
            let l:last_add_status = l:popup_info['lastline'] + l:popup_info['core_height']
            if l:last_add_status <=# g:pop_trans_list_length
                call popup_setoptions(a:popup_obj_id, {'firstline': l:popup_info['lastline'] + 1})
            else
                call popup_setoptions(a:popup_obj_id, {'firstline': g:pop_trans_list_length - l:popup_info['core_height'] + 1})
            endif
        else
            let l:last_add_status = l:popup_info['firstline'] - l:popup_info['core_height']
            if l:last_add_status >=# 1
                call popup_setoptions(a:popup_obj_id, {'firstline': l:last_add_status})
            else
                call popup_setoptions(a:popup_obj_id, {'firstline': 1})
            endif
        endif
    endif
endfunction

" load dict files
if filereadable(g:gtrans_dict_path)
    let s:dict_lines = readfile(g:gtrans_dict_path)
else
    let s:dict_lines = []
endif
call add(s:dict_lines, "")

function! gtrans#SaveToDict() abort
    if exists("g:pop_trans_list")
        let l:line = [join(g:pop_trans_list[-2:], "")]
        if index(s:dict_lines, l:line[0]) ==# -1
            call add(s:dict_lines, l:line)
            if filewritable(g:gtrans_dict_path)
                call writefile(l:line, g:gtrans_dict_path, "a")
            else
                call writefile(l:line, g:gtrans_dict_path, "w")
            endif
        endif
    endif
endfunction

function! gtrans#BrowseDict() abort
    execute ":e " . g:gtrans_dict_path
endfunction
