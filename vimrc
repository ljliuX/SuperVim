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
" Last Modified: 2019-09-28 21:16
" ============================================================================
" SuperVim {{{
" ============================================================================

" 默认主题
let g:SuperVim_theme = 'gruvbox'

" 运行目录
let g:SuperVim_home = $HOME.'/.SuperVim'

" 插件下载目录
let g:SuperVim_plug_dir = g:SuperVim_home.'/plugged'

" 缓存文件目录
let g:SuperVim_cache_dir = g:SuperVim_home.'/cache'

" 设置 leader 键
let mapleader = "\<Space>"

" }}}
" ============================================================================
" 初始化 {{{
" ============================================================================

" ----------------------------------------------------------------------------
" SuperVim 运行目录 {{{
" ----------------------------------------------------------------------------
function InitSuperVim()
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
" 文件缓存目录 {{{
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
" vim 默认配置 {{{
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
" 插件管理器 {{{
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
" 插件加载 {{{
" ============================================================================
call plug#begin(g:SuperVim_plug_dir)
Plug 'morhetz/gruvbox'
Plug 'mhinz/vim-startify'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'scrooloose/nerdtree', { 'on': ['NERDTreeToggle', 'NERDTreeFind'] }
Plug 'neomake/neomake'
Plug 'Yggdroot/LeaderF', { 'do': './install.sh' }
if executable('ctags')
	Plug 'majutsushi/tagbar', { 'on': 'TagbarToggle' }
	Plug 'ludovicchabant/vim-gutentags'
endif
" 自动补全
if has('python3')
	if has('nvim')
		Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
	else
		Plug 'Shougo/deoplete.nvim'
		Plug 'roxma/nvim-yarp'
		Plug 'roxma/vim-hug-neovim-rpc'
	endif
	if executable('clang')
		Plug 'Shougo/deoplete-clangx'
	endif
endif
Plug 'octol/vim-cpp-enhanced-highlight', { 'for': ['c', 'cpp'] }
Plug 'tpope/vim-fugitive'
call plug#end()

" }}}
" ============================================================================
" 基础设置 {{{
" ============================================================================

" ----------------------------------------------------------------------------
" 行为 {{{
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
" 界面 {{{
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
set wildmenu
set splitright
set splitbelow

" }}}
" ----------------------------------------------------------------------------
" 缩进选项 {{{
" ----------------------------------------------------------------------------
set nowrap
set tabstop=4
set shiftwidth=4
set expandtab
set smarttab
set autoindent
set smartindent

" }}}
" ----------------------------------------------------------------------------
" 颜色主题 {{{
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
" 插件参数 {{{
" ============================================================================

" ----------------------------------------------------------------------------
" Plugin: airline | 状态栏美化 {{{
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
	if isdirectory(g:SuperVim_plug_dir.'/ale')
		let g:airline#extensions#ale#enabled = 1
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
" Plugin: nerdtree | 文件列表 {{{
" ----------------------------------------------------------------------------
if isdirectory(g:SuperVim_plug_dir.'/nerdtree')
	let NERDTreeWinPos = 'right'
	let NERDTreeWinSize = 31
	let NERDTreeAutoDeleteBuffer = 1
	let NERDTreeIgnore = ['\.o$', '\.git$', '\.svn$']
	" Key: <F3> | 文件列表
	nnoremap <F3> :NERDTreeToggle<CR>
endif

" }}}
" ----------------------------------------------------------------------------
" Plugin: tagbar | 标签列表 {{{
" ----------------------------------------------------------------------------
if isdirectory(g:SuperVim_plug_dir.'/tagbar')
	let g:tagbar_left = 1
	let g:tagbar_width = 31
	let g:tagbar_sort = 0
	" Key: <F2> | 标签列表
	nnoremap <F2> :TagbarToggle<CR>
endif

" }}}
" ----------------------------------------------------------------------------
" Plugin: gruvbox | 配色方案 {{{
" ----------------------------------------------------------------------------
if isdirectory(g:SuperVim_plug_dir.'/gruvbox')
	let g:gruvbox_contrast_dark = 'soft'
	let g:gruvbox_invert_tabline = 1
	let g:gruvbox_improved_warnings = 1
endif

" }}}
" ----------------------------------------------------------------------------
" Plugin: startify | 开始页面 {{{
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
" Plugin: cpp-enhanced-highlight | C++ 高亮增强 {{{
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
" Plugin: gutentags | 标签管理工具 {{{
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
	let g:gutentags_project_root = ['.root', '.git', '.svn']
	let g:gutentags_add_default_project_roots = 0
	let g:gutentags_ctags_tagfile = 'tags'
	let g:gutentags_cache_dir = g:SuperVim_cache_dir.'/tags'
	let g:gutentags_ctags_extra_args  = ['--fields=+niazS', '--extra=+q']
	let g:gutentags_ctags_extra_args += ['--c++-kinds=+px']
	let g:gutentags_ctags_extra_args += ['--c-kinds=+px']
	function InitGutentagsCacheDir()
		if !isdirectory(g:gutentags_cache_dir)
			call system(printf('mkdir -p %s', g:gutentags_cache_dir))
		endif
	endfunction
	call InitGutentagsCacheDir()
endif

" }}}
" ----------------------------------------------------------------------------
" Plugin: deoplete | 自动补全框架 {{{
" ----------------------------------------------------------------------------
if has('python3') && isdirectory(g:SuperVim_plug_dir.'/deoplete.nvim')
	let g:deoplete#enable_at_startup = 1
	if executable('clang')
				\ && isdirectory(g:SuperVim_plug_dir.'/deoplete-clangx')
		call deoplete#custom#var('clangx', 'clang_binary',
					\ system('which clang'))
	endif
endif

" }}}
" ----------------------------------------------------------------------------
" Plugin: vim-fugitive | Git 工具 {{{
" ----------------------------------------------------------------------------
if isdirectory(g:SuperVim_plug_dir.'/vim-fugitive')
	" Key: <Leader>gs | 打开窗口进行 git status 操作
	nnoremap <Leader>gs :Gstatus<CR>gg<C-n>
	" Key: <Leader>gd | vimdiff 当前文件与 HEAD 版本
	nnoremap <Leader>gd :Gdiffsplit!<CR>
	" Key: <Leader>gc | 打开窗口进行 git commit 操作
	nnoremap <Leader>gc :Gcommit<CR>
	" Key: <Leader>gl | 打开 quickfix 窗口，显示提交记录
	nnoremap <Leader>gl :Glog!<CR>
endif

" }}}
" ----------------------------------------------------------------------------

" }}}
" ============================================================================
" 快捷键映射 {{{
" ============================================================================

" Key: <C-j> | 插入模式，移动光标到上一行
inoremap <C-j> <C-o>j
" Key: <C-k> | 插入模式，移动光标到下一行
inoremap <C-k> <C-o>k
" Key: <C-a> | 插入模式，移动光标到行首
inoremap <C-a> <C-o><Home>
" Key: <C-e> | 插入模式，移动光标到行尾
inoremap <C-e> <C-o><End>
" Key: jk | 回到普通模式
inoremap jk <Esc>
xnoremap jk <Esc>
cnoremap jk <Esc>
" Key: <Tab> | 切换标签
nnoremap <Tab> <C-w>w
" Key: <Leader>w | 保存缓冲区
nnoremap <Leader>w :update<CR>
" Key: <Leader>q | 关闭窗口
nnoremap <Leader>q :quit<CR>
" Key: <Leader>p | 切换粘贴模式
nnoremap <Leader>p :setlocal paste!<CR>
" Key: <Leader><Leader> | 取消高亮
nnoremap <Leader><Leader> :nohlsearch<CR>

" }}}
" ============================================================================
" 其他 {{{
" ============================================================================

" ----------------------------------------------------------------------------
" 切换到Git根目录 {{{
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

" ----------------------------------------------------------------------------
" 参考资料 {{{
" ----------------------------------------------------------------------------
" https://github.com/junegunn/dotfiles/blob/master/vimrc

" }}}
" ============================================================================
" vim: set tw=78 ts=4 sw=4 noet foldmethod=marker:
