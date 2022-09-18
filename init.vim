" Show git status on status bar
function! GitStatus() abort
    let git_status = GitGutterGetHunkSummary()
    if git_status ==# [0, 0, 0]
        return printf(gitbranch#name())
    else
        return printf('+%s', gitbranch#name())
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

" vista
let g:vista_executive_for = {
            \ 'cpp': 'nvim_lsp',
            \ 'c': 'nvim_lsp',
            \ 'python': 'nvim_lsp',
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
let g:python3_host_prog = '/usr/bin/python'
let g:MRU_File = $HOME . '/.local/share/nvim/.vim_mru_files'
highlight DiagnosticHint ctermfg=Black
highlight DiagnosticVirtualTextHint cterm=none ctermfg=none ctermbg=none
highlight DiagnosticVirtualTextInfo cterm=none ctermfg=none ctermbg=none
highlight DiagnosticVirtualTextWarn ctermfg=242
highlight DiagnosticVirtualTextError ctermfg=242
call sign_define("DiagnosticSignError", #{text: '!', texthl: 'DiagnosticSignError'})
call sign_define("DiagnosticSignWarn", #{text: '*', texthl: 'DiagnosticSignWarn'})
call sign_define("DiagnosticSignInfo", #{text: "", texthl: 'DiagnosticSignInfo'})
call sign_define("DiagnosticSignHint", #{text: "", texthl: 'DiagnosticSignHint'})

lua << EOF
-- sign hl and marks define
vim.api.nvim_create_autocmd({"TextYankPost"}, {
    pattern = {"*"},
    callback = function() 
    vim.highlight.on_yank({higroup="IncSearch", timeout=200})
    end
    })

local opts = {noremap=true, silent=true}
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
-- Enable completion triggered by <c-x><c-o>
-- vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

-- Mappings.
-- See `:help vim.lsp.*` for documentation on any of the below functions
local bufopts = {noremap=true, silent=true, buffer=bufnr}
vim.keymap.set('n', '<space>dc', vim.lsp.buf.declaration, bufopts)
vim.keymap.set('n', '<space>dd', vim.lsp.buf.definition, bufopts)
vim.keymap.set('n', '<space>k', vim.lsp.buf.hover, bufopts)
vim.keymap.set('n', '<space>di', vim.lsp.buf.implementation, bufopts)
vim.keymap.set('n', '<space>K', vim.lsp.buf.signature_help, bufopts)
-- vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
-- vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
-- vim.keymap.set('n', '<space>wl', function()
--   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
-- end, bufopts)
vim.keymap.set('n', '<space>dt', vim.lsp.buf.type_definition, bufopts)
vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
vim.keymap.set('n', '<space>dr', vim.lsp.buf.references, bufopts)
vim.keymap.set('n', '<space>f', vim.lsp.buf.formatting, bufopts)
end

local lsp_flags = {
    debounce_text_changes=150,
    }

-- Set up nvim-cmp.
local cmp = require'cmp'

cmp.setup({
snippet={},
window={
-- completion = cmp.config.window.bordered(),
-- documentation = cmp.config.window.bordered(),
},
  mapping=cmp.mapping.preset.insert({
  ['<C-b>']=cmp.mapping.scroll_docs(-4),
  ['<C-f>']=cmp.mapping.scroll_docs(4),
  ['<Tab>']=cmp.mapping.complete(),
  ['<Tab>']=cmp.mapping.select_next_item(),
  ['<S-Tab>']=cmp.mapping.select_prev_item(),
  ['<C-j>']=cmp.mapping.abort(),
  }),
  sources=cmp.config.sources({
  {name='nvim_lsp'},
  {name='path'},
  {name='buffer'},
  })
})

-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
require('lspconfig')['pyright'].setup{
handlers={
["textDocument/publishDiagnostics"]=vim.lsp.with(
vim.lsp.diagnostic.on_publish_diagnostics, {
    underline=false,
    virtual_text=false,
    }
),
},
    on_attach=on_attach,
    flags=lsp_flags,
    capabilities=capabilities,
    }

require('lspconfig')['clangd'].setup{
handlers={
["textDocument/publishDiagnostics"]=vim.lsp.with(
vim.lsp.diagnostic.on_publish_diagnostics, {
    underline=false,
    virtual_text=true,
    }
),
},
    on_attach=on_attach,
    flags=lsp_flags,
    capabilities=capabilities,
    }
EOF
