set showtabline=2
set tabline=%!OnyxTabline()

let g:onyx_tabline_bookmarks = ["", "", "", ""]

function! s:limit_width(padding, str)
    let segmentwidth = &columns / 5 - a:padding

    if len(a:str) > segmentwidth
        return "..".a:str[-(segmentwidth-2):]
    endif

    return a:str
endfunction

function! OnyxTabline()
    let s = "%#OnyxTabLine#"

    if getreg("#") != ""
        let s .= " # "
        let s .= s:limit_width(5, getreg("#"))
        let s .= "  "
    endif

    for n in range(4)
        if g:onyx_tabline_bookmarks[n] != ""
            let s .= " ".(n+1).") "
            let s .= s:limit_width(6, g:onyx_tabline_bookmarks[n])
            let s .= "  "
        endif
    endfor

    return s
endfunction

highlight OnyxTabLine guifg=#caeaff guibg=#373b41

nnoremap <silent> <M-1> :<C-u>let g:onyx_tabline_bookmarks[0] = getreg("%") <bar> let &tabline=&tabline<CR>
nnoremap <silent> <M-2> :<C-u>let g:onyx_tabline_bookmarks[1] = getreg("%") <bar> let &tabline=&tabline<CR>
nnoremap <silent> <M-3> :<C-u>let g:onyx_tabline_bookmarks[2] = getreg("%") <bar> let &tabline=&tabline<CR>
nnoremap <silent> <M-4> :<C-u>let g:onyx_tabline_bookmarks[3] = getreg("%") <bar> let &tabline=&tabline<CR>

nnoremap <silent> <expr> <space>1 ":<C-u>e ".g:onyx_tabline_bookmarks[0]."\<CR>"
nnoremap <silent> <expr> <space>2 ":<C-u>e ".g:onyx_tabline_bookmarks[1]."\<CR>"
nnoremap <silent> <expr> <space>3 ":<C-u>e ".g:onyx_tabline_bookmarks[2]."\<CR>"
nnoremap <silent> <expr> <space>4 ":<C-u>e ".g:onyx_tabline_bookmarks[3]."\<CR>"
