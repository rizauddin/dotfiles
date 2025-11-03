"###############################################################################
"
"
" ~/.vimrc
" Author: Rizauddin Saian
" Description:
"   Personal Vim configuration file optimised for development, writing, and
"   teaching. Uses vim-plug for plugin management, Gruvbox colour scheme, and
"   settings tuned for readability, code editing, and LaTeX/Markdown work.
"
" Repository:
"   https://github.com/rizauddin/dotfiles
"
" Management:
"   This file is managed using GNU Stow.
"   To deploy (symlink) it to your home directory:
"     cd ~/.dotfiles && stow -v vim
"
" Notes:
"   - Safe for public sharing (no private paths or credentials)
"   - All plugin installations are handled by vim-plug
"   - If you use this config on a new machine, run inside Vim:
"       :PlugInstall
"   - Machine-specific settings (like font or custom scripts) should go in
"       ~/.vimrc.local
"   - VimTeX is configured to use Skim as the default PDF viewer:
"       let g:Tex_ViewRule_pdf = 'open -a Skim'
"     (If you prefer Zathura, uncomment and adjust the alternative lines:
"       let g:vimtex_view_method = 'zathura'
"       let g:vimtex_view_general_viewer = '/opt/homebrew/bin/zathura')
"   - Emmet snippets include HTML5, Professional, and Bootstrap templates
"     for quick web development.
"###############################################################################

"========================= For MacVim font size =========================
if has("gui_running")
  set guifont=Menlo:h17
  "set guifont=JetBrains\ Mono:h14
  "set guifont=FiraCode-Regular:h15
else
  "set guifont=Menlo:h12
endif

"========================= Bootstrap: vim-plug =========================
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  augroup plug_bootstrap | au!
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
  augroup END
endif

"============================= Essentials ==============================
set nocompatible
filetype plugin indent on
syntax on

" Encoding
set encoding=utf-8

" UI niceties
set number
set relativenumber
set cursorline
set showmatch
set ruler
set visualbell
set laststatus=2
set signcolumn=yes
set termguicolors
set background=dark
set mouse=a
set nowrap

" Search
set ignorecase
set smartcase
set incsearch
set nohlsearch

" Indentation
set expandtab
set shiftwidth=2
set tabstop=2
set softtabstop=2
set shiftround
set autoindent
set smartindent
set smarttab

" Folds
set foldmethod=manual
set foldlevelstart=99

" Leader
"let mapleader = " "
"let maplocalleader = ","

" Performance / UX
set updatetime=300
set completeopt=menuone,noselect
"set clipboard=unnamedplus  " use p to paste from macOS system clipboard
" Normal y/p stay internal
" Map leader shortcuts for system clipboard
nnoremap <leader>y "+y
vnoremap <leader>y "+y
nnoremap <leader>p "+p

" Spelling (buffer-local is pointless in vimrc; set globally)
set spell
set spelllang=en_gb

" Cursor shape (insert vs normal) – tty/kitty/iterm compatible
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"

" Disable arrow keys (normal mode) to encourage hjkl
nnoremap <silent> <Up>    :echo "Use k ya!"<CR>
nnoremap <silent> <Down>  :echo "Use j ya!"<CR>
nnoremap <silent> <Left>  :echo "Use h ya!"<CR>
nnoremap <silent> <Right> :echo "Use l ya!"<CR>

" Open netrw with <leader>cd
nnoremap <leader>cd :Ex<CR>

"============================== Plugins ===============================
call plug#begin('~/.vim/plugged')

" Finder
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" File tree
let g:NERDTreeHijackNetrw = 0 " vim . starts with netrw instead of NerdTree
Plug 'preservim/nerdtree'

" CoC
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" LaTeX
Plug 'lervag/vimtex'
Plug 'KeitaNakamura/tex-conceal.vim' " optional — nicer math symbols

" Copilot
Plug 'github/copilot.vim'

" Emmet
Plug 'mattn/emmet-vim'

" Colorschemes
Plug 'morhetz/gruvbox'
Plug 'sainnhe/gruvbox-material'
"Plug 'ghifarit53/tokyonight-vim'
Plug 'sainnhe/sonokai'

" Comments
Plug 'tpope/vim-commentary'

" Prettier (format on demand). Requires node/yarn.
Plug 'prettier/vim-prettier', { 'do': 'yarn install --frozen-lockfile' }

" Web syntax helpers
Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'jparise/vim-graphql'

" CSS colorizer
Plug 'ap/vim-css-color'

" Tags (ctags integration)
Plug 'ludovicchabant/vim-gutentags'

call plug#end()

"=========================== Colors & Theme ===========================
" set t_Co is obsolete in modern terminals; using termguicolors instead.
set background=dark
"colorscheme gruvbox
" colorscheme gruvbox-material
" colorscheme tokyonight
let g:sonokai_style = 'shusia'  " closest to Tokyonight Storm
colorscheme sonokai

"============================= Filetypes ===============================
" JSON is detected by Vim by default; no need to force a custom syntax file.
" Pretty JSON command
command! PrettyJSON %!python3 -m json.tool

" Markdown tweaks (keep simple and compatible)
augroup markdown_settings
  autocmd!
  autocmd FileType markdown setlocal wrap linebreak
augroup END

"============================= FZF binds ===============================
nnoremap <leader>ff :Files<CR>
nnoremap <leader>fo :History<CR>
nnoremap <leader>fb :Buffers<CR>
nnoremap <leader>fw :Windows<CR>
nnoremap <leader>fq :CList<CR>    " For quickfix list
nnoremap <leader>fh :Helptags<CR>
" Optional: ripgrep search if you have rg
if executable('rg')
  let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --glob "!.git/*"'
  nnoremap <leader>fg :Rg<Space>
endif
" Grep current string
nnoremap <leader>fs :Rg <C-r><C-w><CR>

" Grep for current file name (without extension)
nnoremap <leader>fc :execute 'Rg ' . expand('%:t:r')<CR>

" Find files in your Vim config
nnoremap <leader>fi :Files ~/.vim<CR>

"============================ NERDTree ================================
nnoremap <leader>n :NERDTreeToggle<CR>

"============================= VimTeX ================================
" macOS: Skim is the most reliable. Enable forward/inverse search.
let g:vimtex_view_method = 'skim'
let g:vimtex_view_skim_sync = 1
let g:vimtex_view_skim_activate = 1
let g:vimtex_quickfix_mode = 0
let g:vimtex_compiler_method = 'latexmk'
let g:vimtex_compiler_latexmk = {
      \ 'build_dir' : 'out',
      \ 'options' : [
      \   '-pdf',
      \   '-file-line-error',
      \   '-synctex=1',
      \   '-interaction=nonstopmode',
      \ ],
      \}
" Remove legacy LaTeX-suite viewer setting to avoid confusion:
" (you had: let g:Tex_ViewRule_pdf = 'open -a Skim')

" spell check only for text (not commands)
autocmd FileType tex syntax spell toplevel


"============================= Gutentags ==============================
let g:gutentags_ctags_executable = '/opt/homebrew/bin/ctags'
let g:gutentags_cache_dir = expand('~/.cache/gutentags')
let g:gutentags_project_root = ['.git', '.hg', '.svn']
let g:gutentags_modules = ['ctags']
set tags=./tags;/

" Completion behaviour
inoremap <silent><expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <silent><expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <silent><expr> <CR>    pumvisible() ? coc#_select_confirm() : "\<CR>"

" Trigger completion manually if needed
" inoremap <silent><expr> <C-Space> coc#refresh()

" Use K to show documentation
nnoremap <silent>K :call CocActionAsync('doHover')<CR>

" Format current buffer with Prettier/Coc when available
nnoremap <leader>p :CocCommand prettier.formatFile<CR>

"============================= Emmet ==================================
let g:user_emmet_settings = {
      \ 'html': {
      \   'default_attributes': {
      \     'html': { 'lang': 'en' },
      \     'meta': { 'charset': 'UTF-8' }
      \   },
      \   'snippets': {
      \     'html:5': "<!DOCTYPE html>\n<html lang=\"en\">\n<head>\n\t<meta charset=\"${charset}\">\n\t<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n\t<title>${1:Document}</title>\n</head>\n<body>\n\t${0}\n</body>\n</html>",
      \     'html:min': "<!DOCTYPE html>\n<html>\n<head>\n\t<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n\t<title>${1:Document}</title>\n\t<link rel=\"stylesheet\" href=\"${2:style.css}\">\n</head>\n<body>\n\t${0}\n</body>\n</html>",
      \     'html:pro': "<!DOCTYPE html>\n<html>\n<head>\n\t<meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\">\n\t<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n\t<title>${1:Page Title}</title>\n\t<meta name=\"description\" content=\"${2:Short description for SEO}\">\n\t<link rel=\"icon\" href=\"${3:favicon.ico}\" type=\"image/x-icon\">\n\t<link rel=\"stylesheet\" href=\"${4:style.css}\">\n\t<!-- Open Graph / Social -->\n\t<meta property=\"og:title\" content=\"${1}\">\n\t<meta property=\"og:description\" content=\"${2}\">\n\t<meta property=\"og:image\" content=\"${5:og-image.png}\">\n\t<meta property=\"og:type\" content=\"website\">\n\t<meta property=\"og:url\" content=\"${6:https://example.com}\">\n\t<!-- Twitter Card (optional) -->\n\t<meta name=\"twitter:card\" content=\"summary_large_image\">\n</head>\n<body>\n\t${0}\n</body>\n</html>",
      \     'html:bs': "<!DOCTYPE html>\n<html>\n<head>\n\t<meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">\n\t<title>${1:Bootstrap Page}</title>\n\t<link href=\"https://cdn.jsdelivr.net/npm/bootstrap@5.3.7/dist/css/bootstrap.min.css\" rel=\"stylesheet\" integrity=\"sha384-LN+7fdVzj6u52u30Kp6M/trliBMCMKTyK833zpbD+pXdCLuTusPj697FH4R/5mcr\" crossorigin=\"anonymous\">\n</head>\n<body>\n\t<header>\n\t<nav class=\"navbar navbar-expand-lg navbar-dark bg-dark\">\n\t  <div class=\"container-fluid\">\n\t    <a class=\"navbar-brand\" href=\"#\">${2:Brand}</a>\n\t    <button class=\"navbar-toggler\" type=\"button\" data-bs-toggle=\"collapse\" data-bs-target=\"#navbarNav\" aria-controls=\"navbarNav\" aria-expanded=\"false\" aria-label=\"Toggle navigation\">\n\t      <span class=\"navbar-toggler-icon\"></span>\n\t    </button>\n\t    <div class=\"collapse navbar-collapse\" id=\"navbarNav\">\n\t      <ul class=\"navbar-nav ms-auto\">\n\t        <li class=\"nav-item\"><a class=\"nav-link active\" href=\"#\">Home</a></li>\n\t        <li class=\"nav-item\"><a class=\"nav-link\" href=\"#\">Features</a></li>\n\t        <li class=\"nav-item\"><a class=\"nav-link\" href=\"#\">Pricing</a></li>\n\t        <li class=\"nav-item\"><a class=\"nav-link disabled\" tabindex=\"-1\" aria-disabled=\"true\">Disabled</a></li>\n\t      </ul>\n\t    </div>\n\t  </div>\n\t</nav>\n\t</header>\n\n\t<main class=\"container my-5\">\n\t  <h1 class=\"mb-4\">${3:Hello, Bootstrap 5.3.7!}</h1>\n\t  <p class=\"lead\">${4:Your content goes here.}</p>\n\t</main>\n\n\t<footer class=\"bg-light text-center text-lg-start mt-auto py-3 border-top\">\n\t  <div class=\"container\">\n\t    <span class=\"text-muted\">© ${5:2025} ${2:Brand}. All rights reserved.</span>\n\t  </div>\n\t</footer>\n\n\t<script src=\"https://cdn.jsdelivr.net/npm/bootstrap@5.3.7/dist/js/bootstrap.bundle.min.js\" integrity=\"sha384-ndDqU0Gzau9qJ1lfW4pNLlhNTkCfHzAVBReH9diLvGRem5+R9g2FzA8ZGN954O5Q\" crossorigin=\"anonymous\"></script>\n</body>\n</html>"
      \   }
      \ }
      \}

"========================= HTML tag wrapper ===========================
" Only source helper if it exists
if filereadable(expand('~/.vim/scripts/wrapwithtag.vim'))
  augroup wrapwithtag
    autocmd!
    autocmd FileType html,xml source ~/.vim/scripts/wrapwithtag.vim
  augroup END
endif

" --- Transparent background only in terminal Vim (not MacVim) ---
if !has('gui_running') " terminal Vim only
  if has('termguicolors')
    set termguicolors
  endif

  " Apply once on startup
  silent! highlight Normal      ctermbg=NONE guibg=NONE
  silent! highlight NonText     ctermbg=NONE guibg=NONE
  silent! highlight LineNr      ctermbg=NONE guibg=NONE
  silent! highlight SignColumn  ctermbg=NONE guibg=NONE
  silent! highlight EndOfBuffer ctermbg=NONE guibg=NONE
  silent! highlight NormalNC    ctermbg=NONE guibg=NONE
  silent! highlight VertSplit   ctermbg=NONE guibg=NONE

  " Reapply after any :colorscheme
  augroup TransparentBG
    autocmd!
    autocmd ColorScheme * silent! highlight Normal      ctermbg=NONE guibg=NONE
    autocmd ColorScheme * silent! highlight NonText     ctermbg=NONE guibg=NONE
    autocmd ColorScheme * silent! highlight LineNr      ctermbg=NONE guibg=NONE
    autocmd ColorScheme * silent! highlight SignColumn  ctermbg=NONE guibg=NONE
    autocmd ColorScheme * silent! highlight EndOfBuffer ctermbg=NONE guibg=NONE
    autocmd ColorScheme * silent! highlight NormalNC    ctermbg=NONE guibg=NONE
    autocmd ColorScheme * silent! highlight VertSplit   ctermbg=NONE guibg=NONE
  augroup END
endif


" === LSP ===
" Format current file
"nmap <leader>f  :call CocAction('format')<CR>
function! s:SmartFormat() abort
  if &l:filetype ==# 'vim'
    " Vimscript: use built-in reindent
    normal! gg=G
  else
    " Other filetypes: try Coc format
    try
      call CocAction('format')
    catch /^Vim\%((\a\+)\)\=:E605/
      echohl WarningMsg | echom "No Coc formatter for this filetype" | echohl None
    endtry
  endif
endfunction
nnoremap <silent> <leader>f :call <SID>SmartFormat()<CR>

"=========================== GitHub Copilot ===========================
let g:copilot_node_command = '/Users/riza/.nvm/versions/node/v22.3.0/bin/node'
" Use Ctrl + ] to accept Copilot suggestions
let g:copilot_no_tab_map = v:true
imap <silent><script><expr> <C-l> copilot#Accept("\<CR>")
