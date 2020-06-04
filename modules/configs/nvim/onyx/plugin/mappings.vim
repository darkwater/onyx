"call which_key#register("", "g:which_key_map")

function s:object_submenu(prefix, name)
    let l:plusname = "+".a:name
    let l:obj = {
    \   "name": l:plusname." {text object}",
    \   "'": [a:prefix."'",  a:name." '...'"],
    \   '"': [a:prefix.'"',  a:name.' "..."'],
    \   "(": [a:prefix."(",  a:name." (...)"],
    \   "[": [a:prefix."[",  a:name." [...]"],
    \   "{": [a:prefix."{",  a:name." {...}"],
    \   "<": [a:prefix."<",  a:name." <...>"],
    \   "t": [a:prefix."t",  a:name." <x>...</x>"],
    \   "p": [a:prefix."p",  a:name." paragraph"],
    \   "w": [a:prefix."w",  a:name." word"],
    \   "W": [a:prefix."W",  a:name." WORD"],
    \ }
    let l:obj[a:prefix] = [a:prefix.a:prefix, a:name."-line"]

    return obj
endfunction

function s:motion_submenu(prefix, name)
    let l:plusname = "+".a:name
    let l:obj = {
    \   "name": l:plusname." {motion}",
    \   "$": [a:prefix."$",  a:name." to eol"],
    \   "^": [a:prefix."$",  a:name." to sol"],
    \   "l": [a:prefix."l",  a:name." character"],
    \   "j": [a:prefix."j",  a:name." two lines"],
    \   "a": s:object_submenu(a:prefix."a", a:name." a"),
    \   "i": s:object_submenu(a:prefix."i", a:name." inside"),
    \   "w": [a:prefix."w",  a:name." word"],
    \   "W": [a:prefix."W",  a:name." WORD"],
    \   "~": [":help motion.txt", "(about-motions)"],
    \ }
    let l:obj[a:prefix] = [a:prefix.a:prefix, a:name."-line"]

    return obj
endfunction

let g:which_key_map = {
\   "`": "...",
\   "~": s:motion_submenu("~", "switch-case"),
\   "@": ["@", "execute-macro"],
\   "#": ["#", "find-word-backwards"],
\   "$": ["$", "goto-eol"],
\   "%": ["%", "match-paren"],
\   "^": ["^", "goto-sol"],
\   "&": ["&", "repeat-substitution"],
\   "*": ["*", "find-word"],
\
\   "[": "...",
\   "]": "...",
\   "{": ["{", "prev-paragraph"],
\   "}": ["}", "next-paragraph"],
\   "<": s:motion_submenu("<", "unindent"),
\   ">": s:motion_submenu(">", "indent"),
\
\   ".": [".", "repeat-insert-op"],
\   ",": [",", "repeat-find-reverse"],
\   ";": [";", "repeat-find"],
\   ":": [":", "ex-cmdline"],
\   "/": ["/", "search"],
\   "?": ["?", "search-backwards"],
\   '"': "...",
\
\   "A": ["B", "append-mode-eol"],
\   "a": ["a", "append-mode"],
\   "B": ["B", "backwards-WORD"],
\   "b": ["b", "backwards-word"],
\   "C": ["C", "change-to-eol"],
\   "c": s:motion_submenu("c", "change"),
\   "D": ["D", "delete-to-eol"],
\   "d": s:motion_submenu("d", "delete"),
\   "E": ["E", "end-of-WORD"],
\   "e": ["e", "end-of-word"],
\   "F": { "name": "+find-character-backwards", "-": ["F-", "press character to find (backwards)"] },
\   "f": { "name": "+find-character", "-": ["f-", "press character to find"] },
\   "G": ["G", "goto-eof"],
\   "g": "...",
\   "H": ["H", "high-cursor-position"],
\   "h": ["h", "move-left"],
\   "I": ["I", "insert-mode-sol"],
\   "i": ["i", "insert-mode"],
\   "J": ["J", "join-lines"],
\   "j": ["j", "move-down"],
\   "K": "...",
\   "k": ["k", "move-up"],
\   "L": ["L", "low-cursor-position"],
\   "l": ["l", "move-right"],
\   "M": ["M", "middle-cursor-position"],
\   "m": { "name": "+mark-position", "-": ["m-", "press character for mark (then ` to jump)"] },
\   "N": ["N", "next-result-backwards"],
\   "n": ["n", "next-result"],
\   "O": ["O", "open-line-above"],
\   "o": ["o", "open-line"],
\   "P": ["P", "paste-before"],
\   "p": ["p", "paste"],
\   "Q": ["Q", "ex-mode"],
\   "q": { "name": "+record-macro", "-": ["q-", "press character for macro (then q to stop)"] },
\   "R": ["R", "replace-mode"],
\   "r": { "name": "+replace-character", "-": ["r-", "press character to replace with"] },
\   "S": ["S", "substitute-line"],
\   "s": s:motion_submenu("s", "substitute"),
\   "T": { "name": "+till-character-backwards", "-": ["T-", "press character to find (backwards)"] },
\   "t": { "name": "+till-character", "-": ["t-", "press character to find"] },
\   "U": ["U", "undo-line"],
\   "u": ["u", "undo"],
\   "V": ["V", "visual-line-mode"],
\   "v": ["v", "visual-mode"],
\   "W": ["W", "WORD"],
\   "w": ["w", "word"],
\   "X": ["X", "exterminate-character-backwards"],
\   "x": ["x", "exterminate-character"],
\   "Y": "...",
\   "y": s:motion_submenu("y", "yank"),
\   "Z": "...",
\   "z": "...",
\
\   "\<C-^>": ["\<C-^>", "last-buffer"],
\   "\<C-a>": ["\<C-a>", "increment-number"],
\   "\<C-b>": ["\<C-b>", "backward-page"],
\   "\<C-d>": ["\<C-d>", "down-half-page"],
\   "\<C-e>": ["\<C-e>", "scroll-down"],
\   "\<C-f>": ["\<C-f>", "forward-page"],
\   "\<C-h>": ["\<C-h>", "visual-block-mode"],
\   "\<C-o>": ["\<C-o>", "goto-prev-position"],
\   "\<C-q>": ["\<C-q>", "visual-block-mode"],
\   "\<C-r>": ["\<C-r>", "redo"],
\   "\<C-u>": ["\<C-u>", "up-page"],
\   "\<C-v>": ["\<C-v>", "visual-block-mode"],
\   "\<C-w>": ["\<C-w>", "visual-block-mode"],
\   "\<C-x>": ["\<C-x>", "decrement-number"],
\   "\<C-y>": ["\<C-y>", "scroll-up"],
\   "\<C-z>": ["\<C-z>", "suspend"],
\ }

let g:which_key_map.g = {
\   "name": "+misc",
\   "E": ["gE", "end-of-WORD-backwards"],
\   "e": ["ge", "end-of-word-backwards"],
\   "f": ["gf", "goto-file-under-cursor"],
\   "g": ["gg", "goto-top"],
\   "i": ["gi", "insert-mode-again"],
\   "j": ["gj", "move-down-visually"],
\   "k": ["gk", "move-up-visually"],
\   "p": ["gp", "paste-and-move-after"],
\   "q": s:motion_submenu("gq", "format"),
\   "s": ["gs", "freeze"],
\   "U": s:motion_submenu("gU", "upcase"),
\   "u": s:motion_submenu("gu", "downcase"),
\   "v": ["gv", "visual-mode-again"],
\   "w": s:motion_submenu("gw", "inplace-format"),
\   "?": s:motion_submenu("g?", "rot-13"),
\   ";": ["g;", "goto-prev-change"],
\   ",": ["g,", "goto-next-change"],
\ }

let g:which_key_map["`"] = {
\   "name": "+goto-mark",
\   "`": ["``", "last-position"],
\   "0": ["`0", "last-quit-position"],
\   "a": ["`a", "local-a"],
\   "A": ["`A", "global-a"],
\   "b": ["`b", "local-b"],
\   "B": ["`B", "global-b"],
\   "c": ["`c", "local-c"],
\   "C": ["`C", "global-c"],
\   "d": ["`d", "local-d"],
\   "D": ["`D", "global-d"],
\   "<": ["`<", "last-selection-start"],
\   ">": ["`>", "last-selection-end"],
\   ".": ["`.", "last-change"],
\   "~": [":help mark-motions", "(about-marks)"],
\ }

let g:which_key_map['"'] = {
\   "name": "+select-register",
\   "#": [':call feedkeys("\"#")',  "alternate-filename"],
\   "%": [':call feedkeys("\"%")',  "current-filename"],
\   "*": [':call feedkeys("\"*")',  "xorg-primary"],
\   "+": [':call feedkeys("\"+")',  "xorg-clipboard"],
\   "-": [':call feedkeys("\"-")',  "last-small-delete"],
\   ".": [':call feedkeys("\".")',  "last-insert"],
\   "/": [':call feedkeys("\"/")',  "last-search"],
\   "0": [':call feedkeys("\"0")',  "last-yank"],
\   "1": [':call feedkeys("\"1")',  "1st-last-delete"],
\   "2": [':call feedkeys("\"2")',  "2nd-last-delete"],
\   "3": [':call feedkeys("\"3")',  "3rd-last-delete"],
\   "4": [':call feedkeys("\"4")',  "3rd-last-delete"],
\   ":": [':call feedkeys("\":")',  "last-ex-cmdline"],
\   "=": [':call feedkeys("\"=")',  "expression"],
\   "a": [':call feedkeys("\"a")',  "register-a"],
\   "A": [':call feedkeys("\"A")',  "register-a-append"],
\   "b": [':call feedkeys("\"b")',  "register-b"],
\   "B": [':call feedkeys("\"B")',  "register-b-append"],
\   "c": [':call feedkeys("\"c")',  "register-c"],
\   "C": [':call feedkeys("\"C")',  "register-c-append"],
\   "d": [':call feedkeys("\"d")',  "register-d"],
\   "D": [':call feedkeys("\"D")',  "register-d-append"],
\   "_": [':call feedkeys("\"_")',  "black-hole"],
\   '"': [':call feedkeys("\"\"")', "unnamed-register"],
\   "~": [":help registers", "(about-registers)"],
\ }

" fix vim
nnoremap Y y$
let g:which_key_map.Y = ["y$", "yank-to-eol"]

" special keys
let g:which_key_map.y.s = s:motion_submenu("ys", "surround")
let g:which_key_map.q[":"] = ["q:", "ex-history"]

" which-key settings
let g:which_key_fallback_to_native_key = 1

nnoremap <silent> <A-/> :<C-u>WhichKey! g:which_key_map<CR>

function s:map_key(keys, description, flags, input)
    if a:keys !~ '^<.\+>$'
        let l:pointer = g:which_key_map

        for n in range(strlen(a:keys)-1)
            let l:key = a:keys[n]
            if !has_key(l:pointer, l:key)
                let l:pointer[l:key] = {}
            endif
            let l:pointer = l:pointer[l:key]
        endfor

        let l:key = a:keys[strlen(a:keys)-1]
        let l:pointer[l:key] = [ ":call feedkeys('".a:keys."')", a:description ]
    else
        let g:which_key_map[expand('\'.a:keys)] = [ ":call feedkeys('\\".a:keys."','t')", a:description ]
    endif

    execute "nnoremap" a:flags a:keys a:input
endfunction

" --- onyx bindings --- "

call s:map_key("\\", "ex-cmdline", "", ":")

call s:map_key("\<C-l>", "redraw-screen", "<silent>", "<C-l>:nohlsearch<CR>")
call s:map_key("\<C-s>", "save", "<silent>", ":<C-u>w<CR>")
inoremap <silent> <C-s> <Esc>:w<CR>

call s:map_key('"?', "display-registers", "", ":<C-u>display<CR>")

call s:map_key("K",  "lsp-hover",           "<silent>", ":<C-u>call CocAction('doHover')<CR>")
call s:map_key("ga", "lsp-action",          "<silent>", ":<C-u>CocCommand actions.open<CR>")
call s:map_key("gd", "lsp-goto-definition", "<silent>", ":<C-u>call CocAction('jumpDefinition')<CR>")
call s:map_key("gR", "lsp-references",      "<silent>", ":<C-u>call CocAction('jumpReferences')<CR>")
call s:map_key("gr", "lsp-rename",          "<silent>", ":<C-u>call CocAction('rename')<CR>")

call s:map_key("\<C-space>", "open-terminal", "<silent>", ":<C-u>FloatermToggle<CR>")
inoremap <C-Space> <C-o>:FloatermToggle<CR>
tnoremap <C-Space> <C-\><C-n>:FloatermToggle<CR>
