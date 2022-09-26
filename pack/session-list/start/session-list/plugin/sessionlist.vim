command! -nargs=0 Ldsession :call sessionlist#LoadSession()
command! -nargs=+ -bang Mksession :call sessionlist#SaveSession(<bang>0, <f-args>)
