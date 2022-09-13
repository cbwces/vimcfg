" Author: cbwces <sknyqbcbw@gmail.com>
" Date  : 20220819
function! s:Eatchar(pat)
    let c = nr2char(getchar(0))
    return (c =~ a:pat) ? '' : c
endfunction

" python abbrev
augroup python_abbrev
    autocmd!
    autocmd FileType python inoreabbrev <silent> <buffer> inp import numpy as np<CR><C-R>=<SID>Eatchar('\s')<CR>
    autocmd FileType python inoreabbrev <silent> <buffer> ipd import pandas as pd<CR><C-R>=Eatchar('\s')<CR>
    autocmd FileType python inoreabbrev <silent> <buffer> itorch import torch<CR><C-R>=<SID>Eatchar('\s')<CR>
    autocmd FileType python inoreabbrev <silent> <buffer> idataset from torch.utils.data import Dataset<CR><C-R>=<SID>Eatchar('\s')<CR>
    autocmd FileType python inoreabbrev <silent> <buffer> idataloader from torch.utils.data import DataLoader<CR><C-R>=<SID>Eatchar('\s')<CR>
    autocmd FileType python inoreabbrev <silent> <buffer> innn import torch.nn as nn<CR><C-R>=<SID>Eatchar('\s')<CR>
    autocmd FileType python inoreabbrev <silent> <buffer> innf import torch.nn.functional as F<CR><C-R>=<SID>Eatchar('\s')<CR>
    autocmd FileType python inoreabbrev <silent> <buffer> imain if __name__ == '__main__':<CR><C-R>=<SID>Eatchar('\s')<CR>
    autocmd FileType python inoreabbrev <silent> <buffer> ilearn import numpy as np<CR>import torch<CR>import torch.nn as nn<CR>import torch.nn.functional as F<CR><C-R>=<SID>Eatchar('\s')<CR>
    autocmd FileType python inoreabbrev <silent> <buffer> iinit def __init__(self,)<Left>
augroup end
