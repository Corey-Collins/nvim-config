set tabstop=4								" num visual spaces per tab
set shiftwidth=4							" num visual spaces used for each step of (auto)indent
set expandtab								" convert tab to spaces
set autoindent
set smartindent
autocmd FileType html,vue,css setlocal shiftwidth=2 softtabstop=2
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
" set guicursor=
" set signcolumn=number

call plug#begin('~/.config/nvim/plugged')
Plug 'EdenEast/nightfox.nvim'
Plug 'MeanderingProgrammer/markdown.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/nvim-treesitter-context'
" Plug 'wellle/context.vim'
Plug 'rust-lang/rust.vim'
Plug 'neovim/nvim-lspconfig'
Plug 'prabirshrestha/vim-lsp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.4' }
" Plug 'kyazdani42/nvim-web-devicons'
" Plug 'folke/trouble.nvim'
Plug 'akinsho/toggleterm.nvim', {'tag' : '*'}
Plug 'kyazdani42/nvim-web-devicons'
Plug 'kyazdani42/nvim-tree.lua'
Plug 'averms/black-nvim', {'do': ':UpdateRemotePlugins'}
Plug 'tpope/vim-surround'
Plug 'JoosepAlviste/nvim-ts-context-commentstring'
Plug 'windwp/nvim-autopairs'
Plug 'windwp/nvim-ts-autotag'
Plug 'luckasRanarison/tailwind-tools.nvim'
Plug 'onsails/lspkind-nvim'

Plug 'olimorris/codecompanion.nvim'

" Debugger
Plug 'mfussenegger/nvim-dap'
Plug 'nvim-neotest/nvim-nio'
Plug 'rcarriga/nvim-dap-ui'
Plug 'theHamsta/nvim-dap-virtual-text'
Plug 'mrcjkb/rustaceanvim'
call plug#end()

set rtp+=~/.config/nvim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'

" Add plugins here
"Plugin 'jiangmiao/auto-pairs'
" Plugin 'tpope/vim-commentary'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

call vundle#end()

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

" airline theme
let g:airline_theme='base16'

" makes background transparent
" hi Normal guibg=NONE ctermbg=NONE

" auto close if NvimTree last window
autocmd BufEnter * ++nested if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif

lua require("corey-collins")
