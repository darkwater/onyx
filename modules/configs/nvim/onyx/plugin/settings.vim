" backup
set backup
set backupdir=~/.local/share/nvim/backup

" buffers
set hidden

" completion
set wildmenu

" display
set list
set nowrap
set number
set relativenumber
set scrolloff=5
set showcmd
set showmode
set sidescroll=5
set smartcase

" indentation
set autoindent
set expandtab
set shiftwidth=4
set tabstop=4

" search
set hlsearch
set ignorecase
set incsearch

" tui
set termguicolors
set title

" undo
set undofile
set undolevels=1000

" windows
set splitbelow
set splitright

set background=dark
set backspace=start,eol,indent
set cmdheight=1
set completeopt=menu,longest,noselect
set conceallevel=2
set fillchars=fold:\ ,vert:\ 
set history=10000
set inccommand=nosplit
set iskeyword=@,48-57,_,192-255
set laststatus=2
set listchars=extends:+,nbsp:%,precedes:+,tab:┃·,trail:░
set mouse=a
set numberwidth=6
set pastetoggle=<F11>
set pumblend=12
set switchbuf=useopen
set textwidth=80
set timeoutlen=800
set ttimeoutlen=5
set updatetime=400
set viewoptions=cursor
" set wildchar=<Tab>
" set wildmode=longest
set wildoptions=pum,tagfile
set winblend=12
set winminwidth=8
set winwidth=80

nohlsearch
colors tomorrow-night
syntax on
filetype plugin indent on

" gnu screen can't do 24-bit colors
if $TERM =~ '^screen'
    set notermguicolors
endif
