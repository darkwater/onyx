augroup Mkdir
    au!
    au BufWritePre * if getftype(expand("%:h")) == ""
    au BufWritePre *     echo "Directory ".expand("%:h")." does not exist."
    au BufWritePre *     if confirm("$ mkdir ".expand("%:h")."?", "&Yes\n&No", 2) == 1
    au BufWritePre *         call mkdir(expand("%:h"), "p")
    au BufWritePre *     endif
    au BufWritePre * endif
augroup END
