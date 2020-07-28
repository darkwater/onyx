augroup Binary
    autocmd!

    autocmd BufReadPre   *.bin let &bin=1
    autocmd BufReadPost  *.bin if &bin
    autocmd BufReadPost  *.bin     %!xxd
    autocmd BufReadPost  *.bin     set ft=xxd
    autocmd BufReadPost  *.bin endif
    autocmd BufWritePre  *.bin if &bin
    autocmd BufWritePre  *.bin     %!xxd -r
    autocmd BufWritePre  *.bin endif
    autocmd BufWritePost *.bin if &bin
    autocmd BufWritePost *.bin     %!xxd
    autocmd BufWritePost *.bin     set nomod
    autocmd BufWritePost *.bin endif
augroup end
