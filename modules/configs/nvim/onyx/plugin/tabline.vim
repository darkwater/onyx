set showtabline=2
set tabline=%!OnyxTabline()

if !exists("g:onyx_tabline_bookmarks")
    let g:onyx_tabline_bookmarks = argv()
    while len(g:onyx_tabline_bookmarks) < 5
        call add(g:onyx_tabline_bookmarks, "")
    endwhile
endif

function! s:limit_width(padding, str)
    let l:used = len(filter(copy(g:onyx_tabline_bookmarks), {_,n -> n != ""}))
    let segmentwidth = &columns / l:used - a:padding

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

    for n in range(5)
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
nnoremap <silent> <space>s5 :<C-u>let g:onyx_tabline_bookmarks[4] = expand("%:p") <bar> let &tabline=&tabline<CR>

nnoremap <silent> <space>d1 :<C-u>let g:onyx_tabline_bookmarks[0] = "" <bar> let &tabline=&tabline<CR>
nnoremap <silent> <space>d2 :<C-u>let g:onyx_tabline_bookmarks[1] = "" <bar> let &tabline=&tabline<CR>
nnoremap <silent> <space>d3 :<C-u>let g:onyx_tabline_bookmarks[2] = "" <bar> let &tabline=&tabline<CR>
nnoremap <silent> <space>d4 :<C-u>let g:onyx_tabline_bookmarks[3] = "" <bar> let &tabline=&tabline<CR>
nnoremap <silent> <space>d5 :<C-u>let g:onyx_tabline_bookmarks[4] = "" <bar> let &tabline=&tabline<CR>

nnoremap <silent> <expr> <space>1 ":<C-u>e ".g:onyx_tabline_bookmarks[0]."\<CR>"
nnoremap <silent> <expr> <space>2 ":<C-u>e ".g:onyx_tabline_bookmarks[1]."\<CR>"
nnoremap <silent> <expr> <space>3 ":<C-u>e ".g:onyx_tabline_bookmarks[2]."\<CR>"
nnoremap <silent> <expr> <space>4 ":<C-u>e ".g:onyx_tabline_bookmarks[3]."\<CR>"
nnoremap <silent> <expr> <space>5 ":<C-u>e ".g:onyx_tabline_bookmarks[4]."\<CR>"
