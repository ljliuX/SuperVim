" vim: set tw=78 ts=4 sw=4 noet fdm=marker:
" ============================================================================
"                 _____                      _    ___
"                / ___/__  ______  ___  ____| |  / (_)___ ___
"                \__ \/ / / / __ \/ _ \/ ___/ | / / / __ `__ \
"               ___/ / /_/ / /_/ /  __/ /   | |/ / / / / / / /
"              /____/\__,_/ .___/\___/_/    |___/_/_/ /_/ /_/
"                        /_/
"
" Author: ljliu <ljliu.cc@gmail.com>
" Source: https://github.com/ljliuX/SuperVim
" Last Modified: 2019-12-29 03:16
" ============================================================================
" SuperVim {{{
" ============================================================================

let g:SuperVim_theme = 'gruvbox'
let g:SuperVim_home = $HOME.'/.SuperVim'
let g:SuperVim_plug_dir = g:SuperVim_home.'/plugged'
let g:SuperVim_cache_dir = g:SuperVim_home.'/cache'
let mapleader = "\<Space>"

" }}}
" ============================================================================
" Init {{{
" ============================================================================

" ----------------------------------------------------------------------------
" SuperVim runtime {{{
" ----------------------------------------------------------------------------
function! InitSuperVim()
	if !isdirectory(g:SuperVim_home)
		call system(printf('mkdir -p %s', g:SuperVim_home))
	endif
	let l:default_vim_home = $HOME.'/.vim'
	if !has('nvim') && isdirectory(l:default_vim_home)
		echomsg 'backup your ~/.vim directory'
		call system(printf('mv %s{,_%s}',
					\ l:default_vim_home, strftime('%Y%m%d%H%M%S')))
	endif
endfunction
call InitSuperVim()

" }}}
" ----------------------------------------------------------------------------
" Cache directory {{{
" ----------------------------------------------------------------------------
function! InitCacheDirs()
	let l:dir_list = {
				\ 'backup': 'backupdir',
				\ 'views': 'viewdir',
				\ 'swap': 'directory',
				\ 'undo': 'undodir'
				\ }
	for [dirname, settingname] in items(l:dir_list)
		let directory = printf('%s/%s', g:SuperVim_cache_dir, dirname)
		if !isdirectory(directory)
			call system(printf('mkdir -p %s', directory))
		endif
		execute printf('set %s=%s', settingname, directory)
	endfor
endfunction
call InitCacheDirs()

" }}}
" ----------------------------------------------------------------------------
" Default vim scripts {{{
" ----------------------------------------------------------------------------
function! InitVimDefault()
	let l:vim_default = $VIMRUNTIME.'/defaults.vim'
	if !has('nvim') && filereadable(l:vim_default)
		execute 'source '.l:vim_default
	endif
endfunction
call InitVimDefault()

" }}}
" ----------------------------------------------------------------------------
" Init Plugin Manager {{{
" ----------------------------------------------------------------------------
function! InitVimPlug()
	let l:vim_plug_dir = g:SuperVim_plug_dir.'/vim-plug'
	if !isdirectory(l:vim_plug_dir)
		echomsg 'install vim-plug'
		let l:vim_plug_url = 'https://raw.githubusercontent.com'
					\ .'/junegunn/vim-plug/master/plug.vim'
		call system(printf('curl -Lo %s/autoload/plug.vim --create-dirs %s',
					\ l:vim_plug_dir, l:vim_plug_url))
	endif
	execute 'set runtimepath+='.l:vim_plug_dir
endfunction
call InitVimPlug()

" }}}
" ----------------------------------------------------------------------------

" }}}
" ============================================================================
" Plugins {{{
" ============================================================================
call plug#begin(g:SuperVim_plug_dir)
Plug 'morhetz/gruvbox'
Plug 'mhinz/vim-startify'
Plug 'vim-airline/vim-airline'
Plug 'scrooloose/nerdtree', { 'on': ['NERDTreeToggle', 'NERDTreeFind'] }
if executable('ctags')
	Plug 'majutsushi/tagbar', { 'on': 'TagbarToggle' }
	Plug 'ludovicchabant/vim-gutentags'
	if executable('gtags-cscope') && executable('gtags')
		Plug 'skywind3000/gutentags_plus', { 'on': 'GscopeFind' }
	endif
endif
if has('python3')
	Plug 'Yggdroot/LeaderF', { 'do': './install.sh' }
	if has('nvim')
		Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
	else
		Plug 'Shougo/deoplete.nvim'
		Plug 'roxma/nvim-yarp'
		Plug 'roxma/vim-hug-neovim-rpc'
	endif
	Plug 'Shougo/echodoc.vim'
	if executable('clang')
		Plug 'Shougo/deoplete-clangx'
	endif
	Plug 'voldikss/vim-translator'
endif
Plug 'sbdchd/neoformat', { 'on': 'Neoformat' }
Plug 'octol/vim-cpp-enhanced-highlight', { 'for': ['c', 'cpp'] }
Plug 'tpope/vim-fugitive'
Plug 'skywind3000/asyncrun.vim'
call plug#end()

" }}}
" ============================================================================
" Plugin Settings {{{
" ============================================================================

" ----------------------------------------------------------------------------
" Plugin: airline | Beautify statusline {{{
" ----------------------------------------------------------------------------
if isdirectory(g:SuperVim_plug_dir.'/vim-airline')
	let g:airline#extensions#tabline#enabled = 1
	let g:airline#extensions#tabline#tab_nr_type = 1
	if isdirectory(g:SuperVim_plug_dir.'/tagbar')
		let g:airline#extensions#tagbar#enabled = 1
		let g:airline#extensions#tagbar#flags = 'f'
	endif
	if isdirectory(g:SuperVim_plug_dir.'/gutentags')
		let g:airline#extensions#gutentags#enabled = 1
	endif
	let g:airline#extensions#tabline#buffer_idx_mode = 1
	nmap <leader>1 <Plug>AirlineSelectTab1
	nmap <leader>2 <Plug>AirlineSelectTab2
	nmap <leader>3 <Plug>AirlineSelectTab3
	nmap <leader>4 <Plug>AirlineSelectTab4
	nmap <leader>5 <Plug>AirlineSelectTab5
	nmap <leader>6 <Plug>AirlineSelectTab6
	nmap <leader>7 <Plug>AirlineSelectTab7
	nmap <leader>8 <Plug>AirlineSelectTab8
	nmap <leader>9 <Plug>AirlineSelectTab9
	nmap <leader>- <Plug>AirlineSelectPrevTab
	nmap <leader>+ <Plug>AirlineSelectNextTab
endif

" }}}
" ----------------------------------------------------------------------------
" Plugin: nerdtree | Filesystem explorer {{{
" ----------------------------------------------------------------------------
if isdirectory(g:SuperVim_plug_dir.'/nerdtree')
	let NERDTreeWinPos = 'right'
	let NERDTreeWinSize = 31
	let NERDTreeAutoDeleteBuffer = 1
	let NERDTreeIgnore = ['\.o$', '\.git$', '\.svn$']
	" Key: <F3> | Toggle file list
	nnoremap <F3> :NERDTreeToggle<CR>
endif
" Don't use netrw
let g:loaded_netrw = 1

" }}}
" ----------------------------------------------------------------------------
" Plugin: tagbar | Display tags in a window {{{
" ----------------------------------------------------------------------------
if isdirectory(g:SuperVim_plug_dir.'/tagbar')
	let g:tagbar_left = 1
	let g:tagbar_width = 31
	let g:tagbar_sort = 0
	" Key: <F2> | Toggle tag list window
	nnoremap <F2> :TagbarToggle<CR>
endif

" }}}
" ----------------------------------------------------------------------------
" Plugin: gruvbox | Retro groove color scheme {{{
" ----------------------------------------------------------------------------
if isdirectory(g:SuperVim_plug_dir.'/gruvbox')
	let g:gruvbox_contrast_dark = 'soft'
	let g:gruvbox_invert_tabline = 1
	let g:gruvbox_improved_warnings = 1
endif

" }}}
" ----------------------------------------------------------------------------
" Plugin: startify | Start screen {{{
" ----------------------------------------------------------------------------
let g:startify_custom_header = [
			\ '                 _____                      _    ___          ',
			\ '                / ___/__  ______  ___  ____| |  / (_)___ ___  ',
			\ '                \__ \/ / / / __ \/ _ \/ ___/ | / / / __ `__ \ ',
			\ '               ___/ / /_/ / /_/ /  __/ /   | |/ / / / / / / / ',
			\ '              /____/\__,_/ .___/\___/_/    |___/_/_/ /_/ /_/  ',
			\ '                        /_/                                   '
			\ ]
let g:startify_change_to_dir = 0

" }}}
" ----------------------------------------------------------------------------
" Plugin: cpp-enhanced-highlight | C++ syntax highlighting {{{
" ----------------------------------------------------------------------------
if isdirectory(g:SuperVim_plug_dir.'/vim-cpp-enhanced-highlight')
	let g:cpp_class_scope_highlight = 1
	let g:cpp_member_variable_highlight = 1
	let g:cpp_class_decl_highlight = 1
	let g:cpp_experimental_simple_template_highlight = 1
	let g:cpp_concepts_highlight = 1
endif

" }}}
" ----------------------------------------------------------------------------
" Plugin: gutentags | Tag files manager {{{
" ----------------------------------------------------------------------------
if isdirectory(g:SuperVim_plug_dir.'/vim-gutentags')
	let g:gutentags_define_advanced_commands = 1
	let g:gutentags_modules = []
	if executable('ctags')
		let g:gutentags_modules += ['ctags']
	endif
	if executable('gtags-cscope') && executable('gtags')
		let g:gutentags_modules += ['gtags_cscope']
	endif
	" Excute command *touch .root* to enable
	let g:gutentags_project_root = ['.root']
	let g:gutentags_add_default_project_roots = 0
	let g:gutentags_ctags_tagfile = 'ctags'
	let g:gutentags_cache_dir = g:SuperVim_cache_dir.'/tags'
	if !isdirectory(g:gutentags_cache_dir)
		call system(printf('mkdir -p %s', g:gutentags_cache_dir))
	endif
	let g:gutentags_ctags_extra_args  = ['--fields=+niazS']
	let g:gutentags_ctags_extra_args += ['--c++-kinds=+px']
	let g:gutentags_ctags_extra_args += ['--c-kinds=+px']
	if empty(systemlist('ctags --version | grep "Universal Ctags"'))
		" Exuberant Ctags
		let g:gutentags_ctags_extra_args += ['--extra=+q']
	else
		" Universal Ctags is derived from Exuberant Ctags
		let g:gutentags_ctags_extra_args += ['--extras=+q']
		" let g:gutentags_ctags_extra_args += ['--output-format=e-ctags']
	endif
	let g:gutentags_auto_add_gtags_cscope = 0
	" let g:gutentags_trace = 1
	" gutentags: gtags-cscope job failed, returned: 1
	" https://github.com/ludovicchabant/vim-gutentags/issues/225
	" Resoulved by delete $HOME/.SuperVim/cache

	" Plugin: gutentags_plus | Gtags database manager
	let g:gutentags_plus_nomap = 1
	" Key: <Leader>cs | Find this C symbol
	noremap <silent> <Leader>cs :GscopeFind s <C-r><C-w><CR>
	" Key: <Leader>cg | Find this definition
	noremap <silent> <Leader>cg :GscopeFind g <C-r><C-w><CR>
	" Key: <Leader>cc | Find functions calling this function
	noremap <silent> <Leader>cc :GscopeFind c <C-r><C-w><CR>
	" Key: <Leader>ct | Find this text string
	noremap <silent> <Leader>ct :GscopeFind t <C-r><C-w><CR>
	" Key: <Leader>ce | Find this egrep pattern
	noremap <silent> <Leader>ce :GscopeFind e <C-r><C-w><CR>
	" Key: <Leader>cf | Find this file
	noremap <silent> <Leader>cf :GscopeFind f <C-r>=expand("<cfile>")<CR><CR>
	" Key: <Leader>ci | Find files #including this file
	noremap <silent> <Leader>ci :GscopeFind i <C-r>=expand("<cfile>")<CR><CR>
	" Key: <Leader>cd | Find functions called by this function
	noremap <silent> <Leader>cd :GscopeFind d <C-r><C-w><CR>
	" Key: <Leader>ca | Find assignments to this symbol
	noremap <silent> <Leader>ca :GscopeFind a <C-r><C-w><CR>
endif

" }}}
" ----------------------------------------------------------------------------
" Plugin: deoplete | Asynchronous completion framework {{{
" ----------------------------------------------------------------------------
if has('python3') && isdirectory(g:SuperVim_plug_dir.'/deoplete.nvim')
	let g:deoplete#enable_at_startup = 1
	call deoplete#custom#option({
				\ 'auto_complete_delay': 200,
				\ 'smart_case': v:true,
				\ 'max_list': 50,
				\ 'min_pattern_length': 3,
				\ })
	if executable('clang')
				\ && isdirectory(g:SuperVim_plug_dir.'/deoplete-clangx')
		call deoplete#custom#var('clangx', 'clang_binary',
					\ system('which clang'))
	endif

	" Plugin: echodoc.vim | Displays function signatures
	let g:echodoc_enable_at_startup = 1
endif

" }}}
" ----------------------------------------------------------------------------
" Plugin: vim-fugitive | Git wrapper {{{
" ----------------------------------------------------------------------------
if isdirectory(g:SuperVim_plug_dir.'/vim-fugitive')
	" Key: <Leader>gs | git status
	map      <Leader>gs :Gstatus<CR>gg<C-n>
	" Key: <Leader>gd | git diff
	nnoremap <Leader>gd :Gdiffsplit!<CR>
	" Key: <Leader>gc | git commit
	nnoremap <Leader>gc :Gcommit<CR>
	" Key: <Leader>gl | git log
	nnoremap <Leader>gl :Glog!<CR>
endif

" }}}
" ----------------------------------------------------------------------------
" Plugin: vim-translator | Translate tool {{{
" ----------------------------------------------------------------------------
if isdirectory(g:SuperVim_plug_dir.'/vim-translator')
	let g:translator_target_lang = 'zh'
	let g:translator_default_engines = ['youdao', 'google']
	" Key: <Leader>t | Display the translation in a window
	nmap <silent> <Leader>t <Plug>TranslateW
	vmap <silent> <Leader>t <Plug>TranslateWV
endif

" }}}
" ----------------------------------------------------------------------------
" Plugin: neoformat | Code formater {{{
" ----------------------------------------------------------------------------
if isdirectory(g:SuperVim_plug_dir.'/neoformat')
	if executable('clang-format')
		" To enable: clang-format -style=google -dump-config > .clang-format
		let g:neoformat_clangformat = { 'exe': 'clang-format',
					\ 'args': ['-style=file'], 'stdin': 1 }
		" Specific for C/C++
		let g:neoformat_c_clangformat   = g:neoformat_clangformat
		let g:neoformat_cpp_clangformat = g:neoformat_clangformat
		let g:neoformat_enabled_c       = ['clangformat']
		let g:neoformat_enabled_cpp     = ['clangformat']
	endif
endif

" }}}
" ----------------------------------------------------------------------------
" Plugin: asyncrun.vim | Run Async Shell Commands {{{
" ----------------------------------------------------------------------------
if isdirectory(g:SuperVim_plug_dir.'/asyncrun.vim')
	" Key: <Leader><CR> | Run shell command
	nnoremap <Leader><CR> :AsyncRun<Space>
	" Key: <F9> | Toggle Quickfix window
	nnoremap <silent> <F9> :call asyncrun#quickfix_toggle(8)<CR>
	let s:asyncrum_exists = 1
endif

" }}}
" ----------------------------------------------------------------------------
" Plugin: LeaderF | Search tools {{{
" ----------------------------------------------------------------------------
if isdirectory(g:SuperVim_plug_dir.'/LeaderF')
	let g:Lf_CacheDirectory = g:SuperVim_cache_dir.'/leaderf'
	if !isdirectory(g:Lf_CacheDirectory)
		call system(printf('mkdir -p %s', g:Lf_CacheDirectory))
	endif
endif

" }}}
" ----------------------------------------------------------------------------

" }}}
" ============================================================================
" Basic {{{
" ============================================================================

" ----------------------------------------------------------------------------
" Performance {{{
" ----------------------------------------------------------------------------
set autoread
set autowrite
set lazyredraw
set timeoutlen=500
set fileformats=unix,dos,mac
set fileencodings=ucs-bom,utf-8,cp936,latin1
set backspace=indent,eol,start
set ignorecase
set magic
set hlsearch
set incsearch
filetype plugin indent on

" }}}
" ----------------------------------------------------------------------------
" Interface {{{
" ----------------------------------------------------------------------------
set shortmess=atI
set mouse=
set number
set relativenumber
set textwidth=78
set colorcolumn=+1
set cursorline
set list
set listchars=tab:\|\ ,trail:-
set laststatus=2
set noshowmode
set wildmenu
set splitright
set splitbelow
set modeline
set complete-=i
set completeopt=menu

" }}}
" ----------------------------------------------------------------------------
" Indent {{{
" ----------------------------------------------------------------------------
set nowrap
set tabstop=4
set shiftwidth=4
" set expandtab
set smarttab
set autoindent
set smartindent

" }}}
" ----------------------------------------------------------------------------
" Colorscheme {{{
" ----------------------------------------------------------------------------
set t_Co=256
set background=dark

if !exists("g:syntax_on")
	syntax enable
endif

try
	execute 'colorscheme' g:SuperVim_theme
catch
	colorscheme desert
endtry

" }}}
" ----------------------------------------------------------------------------

" }}}
" ============================================================================
" Mappings {{{
" ============================================================================

" Key: <F1> | Toggle relative line number
nnoremap <F1> :setlocal relativenumber!<CR>
" Key: ]q | Next Quickfix error
nnoremap ]q :cnext<CR>
" Key: [q | Previous Quickfix error
nnoremap [q :cprev<CR>
" Key: ]b | Next buffer in buffer list
nnoremap ]b :bnext<CR>
" Key: [b | Previous buffer in buffer list
nnoremap [b :bprev<CR>
" Key: ]t | Go to the next tab page
nnoremap ]t :tabnext<CR>
" Key: [t | Go to the previous tab page
nnoremap [t :tabprev<CR>
" Key: <C-j> | Downword in insert mode
inoremap <C-j> <C-o>j
" Key: <C-k> | Upward in insert mode
inoremap <C-k> <C-o>k
" Key: <C-a> | To first char in insert mode
inoremap <C-a> <C-o><Home>
" Key: <C-e> | To the end of the line in insert mode
inoremap <C-e> <C-o><End>
" Key: jk | Escaping!
inoremap jk <Esc>
xnoremap jk <Esc>
cnoremap jk <Esc>
" Key: <Tab> | Move cursor to next window
nnoremap <Tab> <C-w>w
" Key: <Leader>w | Write when the buffer has been modified
nnoremap <Leader>w :update<CR>
" Key: <Leader>q | Quit the current window
nnoremap <Leader>q :quit<CR>
" Key: <Leader>p | Toggle the paste mode
nnoremap <Leader>p :setlocal paste!<CR>
" Key: <Leader><Leader> | Stop the highlighting
nnoremap <silent> <Leader><Leader> :nohlsearch<CR>

inoremap ' ''<Esc>i
inoremap " ""<Esc>i
inoremap ( ()<Esc>i
inoremap [ []<Esc>i
inoremap { {}<Esc>i

" Key: <Leader>z | Zoom
nnoremap <silent> <leader>z :call <SID>zoom()<CR>
function! s:zoom()
	if winnr('$') > 1
		tab split
	elseif len(filter(map(range(tabpagenr('$')), 'tabpagebuflist(v:val + 1)'),
				\ 'index(v:val, '.bufnr('').') >= 0')) > 1
		tabclose
	endif
endfunction

" Key: <Leader>ev | edit vimrc
nnoremap <Leader>ev :vsp $MYVIMRC<CR>
" Key: <Leader>sv | source vimrc
nnoremap <Leader>sv :source $MYVIMRC<CR>

" }}}
" ============================================================================
" Others {{{
" ============================================================================

" ----------------------------------------------------------------------------
" Change directory to the root of the Git repository {{{
" ----------------------------------------------------------------------------
function! s:root()
	let root = systemlist('git rev-parse --show-toplevel')[0]
	if v:shell_error
		echo 'Not in git repo'
	else
		execute 'cd' root
		echo 'Changed directory to: '.root
	endif
endfunction
command! Root call s:root()

" }}}
" ----------------------------------------------------------------------------
" AUTOCMD {{{
" ----------------------------------------------------------------------------
augroup vimrc
	" Unset paste on InsertLeave
	au InsertLeave * silent! set nopaste

	" Automatic rename of tmux window
	if exists('$TMUX')
		au BufEnter * if empty(&buftype)
					\| call system('tmux rename-window '.expand('%:t:S'))
					\| endif
		au VimLeave * call system('tmux set-window automatic-rename on')
	endif

	" Open quickfix window when text adds to it
	if exists('s:asyncrum_exists')
		autocmd QuickFixCmdPost * call asyncrun#quickfix_toggle(8, 1)
	endif
augroup END

" }}}
" ----------------------------------------------------------------------------
" References {{{
" ----------------------------------------------------------------------------
" https://github.com/junegunn/dotfiles/blob/master/vimrc
" https://zhuanlan.zhihu.com/p/36279445
" https://github.com/skywind3000/asyncrun.vim/wiki

" }}}
" ----------------------------------------------------------------------------

" }}}
" ============================================================================
