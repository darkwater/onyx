set showtabline=2
set tabline=%!OnyxTabline()

let g:onyx_tabline_bookmarks = ["", "", "", ""]

function! s:limit_width(padding, str)
    let segmentwidth = &columns / 5 - a:padding

    if len(a:str) > segmentwidth
        return "..".a:str[-(segmentwidth-2):]
    else
        return a:str
    endif
endfunction

function! OnyxTabline()
    let s = "%#OnyxTabLine#"

    if getreg("#") != ""
        let s .= " # "
        let s .= s:limit_width(5, fnamemodify(expand("#"), ":~:."))
        let s .= "  "
    endif

    for n in range(4)
        if g:onyx_tabline_bookmarks[n] != ""
            let s .= " ".(n+1).") "
            let s .= s:limit_width(6, fnamemodify(g:onyx_tabline_bookmarks[n], ":~:."))
            let s .= "  "
        endif
    endfor

    return s
endfunction

highlight OnyxTabLine guifg=#caeaff guibg=#373b41

nnoremap <silent> <space>s1 :<C-u>let g:onyx_tabline_bookmarks[0] = expand("%:p") <bar> let &tabline=&tabline<CR>
nnoremap <silent> <space>s2 :<C-u>let g:onyx_tabline_bookmarks[1] = expand("%:p") <bar> let &tabline=&tabline<CR>
nnoremap <silent> <space>s3 :<C-u>let g:onyx_tabline_bookmarks[2] = expand("%:p") <bar> let &tabline=&tabline<CR>
nnoremap <silent> <space>s4 :<C-u>let g:onyx_tabline_bookmarks[3] = expand("%:p") <bar> let &tabline=&tabline<CR>

nnoremap <silent> <expr> <space>1 ":<C-u>e ".g:onyx_tabline_bookmarks[0]."\<CR>"
nnoremap <silent> <expr> <space>2 ":<C-u>e ".g:onyx_tabline_bookmarks[1]."\<CR>"
nnoremap <silent> <expr> <space>3 ":<C-u>e ".g:onyx_tabline_bookmarks[2]."\<CR>"
nnoremap <silent> <expr> <space>4 ":<C-u>e ".g:onyx_tabline_bookmarks[3]."\<CR>"
