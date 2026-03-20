set tabstop=4								" num visual spaces per tab
set shiftwidth=4							" num visual spaces used for each step of (auto)indent
set expandtab								" convert tab to spaces
set autoindent
set smartindent
autocmd FileType html,vue,css setlocal shiftwidth=2 softtabstop=2
autocmd FileType terraform setlocal shiftwidth=2 softtabstop=2 tabstop=2
set nowrap
set iskeyword+=- " let you delete words (diw) with symbols like-this
"set iskeyword+=\:
set backspace=indent,eol,start
set number relativenumber
set cursorline
set hidden
set wildmenu
set wildignore+=**/node_modules/**
set path+=**
set termguicolors
set scrolloff=8
set updatetime=50
set clipboard=unnamedplus
let g:python3_host_prog = $HOME . '/.local/venv/nvim/bin/python' " make sure include venv here with pynvim and black installed
let g:rustfmt_autosave = 1
" autocmd BufWritePre *.py execute ':Black'
autocmd BufWritePost *.tf,*.tfvars silent! execute ':!terraform fmt %' | e!
" set guicursor=
" set signcolumn=number

" Bootstrap lazy.nvim early so plugins are available
lua require('corey-collins.lazy')

" All plugins now managed by lazy.nvim!

filetype plugin indent on

syntax on
colorscheme carbonfox
" removes background color
highlight Normal guibg=none

" clears the cursorline
hi clear CursorLine
augroup CLClear
    autocmd! ColorScheme * hi clear CursorLine
augroup END

" makes background transparent
" hi Normal guibg=NONE ctermbg=NONE

" auto close if NvimTree last window
autocmd BufEnter * ++nested if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif

lua require("corey-collins")
