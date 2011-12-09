set nocompatible
filetype off " required by Vundle plumbing

" Vundle
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
so ~/.vim/bundle.vim

let mapleader=","

set number
set ruler
syntax on

" Change cursor shape in iterm2 for insert mode
if exists('$TMUX')
  let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
  let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

" Set encoding
set encoding=utf-8

" Whitespace stuff
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set list listchars=tab:\ \ ,trail:·

" Searching
set hlsearch
set incsearch
set ignorecase
set smartcase

" Tab completion
set wildmode=list:longest,list:full
set wildignore+=*.o,*.obj,.git,*.rbc,*.class,.svn,vendor/gems/*

" Without setting this, ZoomWin restores windows in a way that causes
" equalalways behavior to be triggered the next time CommandT is used.
" This is likely a bludgeon to solve some other issue, but it works
set noequalalways

" NERDTree configuration
let NERDTreeIgnore=['\.pyc$', '\.rbc$', '\~$']
let NERDTreeDirArrows = 1
let NERDTreeMouseMode = 3
map <Leader>n :NERDTreeToggle<CR>

" ZoomWin configuration
map <Leader><Leader> :ZoomWin<CR>

" Turn on jshint errors by default
let g:JSLintHighlightErrorLine = 1
" Gundo configuration
nmap <F5> :GundoToggle<CR>
imap <F5> <ESC>:GundoToggle<CR>

" Remember last location in file
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal g'\"" | endif
endif

function s:setupWrapping()
  set wrap
  set wrapmargin=2
  set textwidth=72
endfunction

" Thorfile, Rakefile, Vagrantfile and Gemfile are Ruby
au BufRead,BufNewFile {Gemfile,Rakefile,Vagrantfile,Thorfile,config.ru} set ft=ruby

" add json syntax highlighting
au BufNewFile,BufRead *.json set ft=javascript

au BufRead,BufNewFile *.txt call s:setupWrapping()

" Less CSS
au BufRead,BufNewFile *.less setfiletype less

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" load the plugin and indent settings for the detected filetype
filetype plugin indent on

" Enable syntastic syntax checking
let g:syntastic_enable_signs=1
let g:syntastic_quiet_warnings=1

" Use modeline overrides
set modeline
set modelines=10

" Default color scheme
set background=dark
color default

" Directories for swp files
set backupdir=~/.vim/backup
set directory=~/.vim/backup

" % to bounce from do to end etc.
runtime! macros/matchit.vim

" Show (partial) command in the status line
set showcmd

" Command-Shift-F for Ack
map <D-F> :Ack<space>

" Command-Option-ArrowKey to switch viewports
map <D-M-Up> <C-w>k
imap <D-M-Up> <Esc> <C-w>k
map <D-M-Down> <C-w>j
imap <D-M-Down> <Esc> <C-w>j
map <D-M-Right> <C-w>l
imap <D-M-Right> <Esc> <C-w>l
map <D-M-Left> <C-w>h
imap <D-M-Left> <C-w>h

" Adjust viewports to the same size
map <Leader>= <C-w>=
imap <Leader>= <Esc><C-w>=

" Don't beep
set visualbell

" Turn on jshint errors by default
let g:JSLintHighlightErrorLine = 1

" Sudo to write
cmap w!! w !sudo tee % >/dev/null

" Highlight cursor line
set cursorline

" Mappings
map <Leader>c :Rcontroller
map <Leader>m :Rmodel

map <C-h> :nohl<CR>
imap <C-l> <Space>=><Space>
map <C-s> <esc>:w<CR>
imap <C-s> <esc>:w<CR>
map <C-t> <esc>:tabnew<CR>
map <C-x> <C-w>c

" Gist.vim
let g:gist_clip_command = 'pbcopy'
let g:gist_detect_filetype = 1
let g:gist_show_privates = 1
let g:gist_open_browser_after_post = 1

" Remove whitespaces
map <f6> :%s/\s\+$//<esc>:nohl<CR>:w<CR>

" Statusline {{{
	" Functions {{{
		" Statusline updater {{{
			" Inspired by StatusLineHighlight by Ingo Karkat
			function! s:StatusLine(new_stl, type, current)
				let current = (a:current ? "" : "NC")
				let type = a:type
				let new_stl = a:new_stl

				" Prepare current buffer specific text
				" Syntax: <CUR> ... </CUR>
				let new_stl = substitute(new_stl, '<CUR>\(.\{-,}\)</CUR>', (a:current ? '\1' : ''), 'g')

				" Prepare statusline colors
				" Syntax: #[ ... ]
				let new_stl = substitute(new_stl, '#\[\(\w\+\)\]', '%#StatusLine'.type.'\1'.current.'#', 'g')

				if &l:statusline ==# new_stl
					" Statusline already set, nothing to do
					return
				endif

				if empty(&l:statusline)
					" No statusline is set, use my_stl
					let &l:statusline = new_stl
				else
					" Check if a custom statusline is set
					let plain_stl = substitute(&l:statusline, '%#StatusLine\w\+#', '', 'g')

					if &l:statusline ==# plain_stl
						" A custom statusline is set, don't modify
						return
					endif

					" No custom statusline is set, use my_stl
					let &l:statusline = new_stl
				endif
			endfunction
		" }}}
		" Color dict parser {{{
			function! s:StatusLineColors(colors)
				for type in keys(a:colors)
					for name in keys(a:colors[type])
						let colors = {'c': a:colors[type][name][0], 'nc': a:colors[type][name][1]}
						let type = (type == 'NONE' ? '' : type)
						let name = (name == 'NONE' ? '' : name)

						if exists("colors['c'][0]")
							exec 'hi StatusLine'.type.name.' ctermbg='.colors['c'][0].' ctermfg='.colors['c'][1].' cterm='.colors['c'][2]
						endif

						if exists("colors['nc'][0]")
							exec 'hi StatusLine'.type.name.'NC ctermbg='.colors['nc'][0].' ctermfg='.colors['nc'][1].' cterm='.colors['nc'][2]
						endif
					endfor
				endfor
			endfunction
		" }}}
	" }}}
	" Default statusline {{{
		let g:default_stl  = ""
		let g:default_stl .= "<CUR>#[Mode] %{&paste ? 'PASTE  ' : ''}%{substitute(mode(), '', '', 'g')} #[ModeS]</CUR>"
		let g:default_stl .= "#[ModFlag]%{&readonly ? 'RO ' : ''}" " RO flag
		let g:default_stl .= " #[FileName]%t " " File name
		let g:default_stl .= "#[ModFlag]%(%M %)" " Modified flag
		let g:default_stl .= "#[BufFlag]%(%H%W %)" " HLP,PRV flags
		let g:default_stl .= "#[FileNameS] " " Separator
		let g:default_stl .= "#[FunctionName] " " Padding/HL group
		let g:default_stl .= "%<" " Truncate right
		let g:default_stl .= "%= " " Right align
		let g:default_stl .= "<CUR>#[FileFormat]%{&fileformat} </CUR>" " File format
		let g:default_stl .= "<CUR>#[FileEncoding]%{(&fenc == '' ? &enc : &fenc)} </CUR>" " File encoding
		let g:default_stl .= "<CUR>#[Separator]  ⊂ #[FileType]%{strlen(&ft) ? &ft : 'n/a'} </CUR>" " File type
		let g:default_stl .= "#[LinePercentS] #[LinePercent] %p%% " " Line/column/virtual column, Line percentage
		let g:default_stl .= "#[LineNumberS] #[LineNumber]  %l#[LineColumn]:%c%V " " Line/column/virtual column, Line percentage
		let g:default_stl .= "%{exists('g:synid') && g:synid ? ' '.synIDattr(synID(line('.'), col('.'), 1), 'name').' ' : ''}" " Current syntax group
	" }}}
	" Color dict {{{
		let s:statuscolors = {
			\   'NONE': {
				\   'NONE'         : [[ 236, 231, 'bold'], [ 232, 244, 'none']]
			\ }
			\ , 'Normal': {
				\   'Mode'         : [[ 214, 235, 'bold'], [                 ]]
				\ , 'ModeS'        : [[ 214, 240, 'bold'], [                 ]]
				\ , 'Branch'       : [[ 240, 250, 'none'], [ 234, 239, 'none']]
				\ , 'BranchS'      : [[ 240, 246, 'none'], [ 234, 239, 'none']]
				\ , 'FileName'     : [[ 240, 231, 'bold'], [ 234, 244, 'none']]
				\ , 'FileNameS'    : [[ 240, 236, 'bold'], [ 234, 232, 'none']]
				\ , 'Error'        : [[ 240, 202, 'bold'], [ 234, 239, 'none']]
				\ , 'ModFlag'      : [[ 240, 196, 'bold'], [ 234, 239, 'none']]
				\ , 'BufFlag'      : [[ 240, 250, 'none'], [ 234, 239, 'none']]
				\ , 'FunctionName' : [[ 236, 247, 'none'], [ 232, 239, 'none']]
				\ , 'FileFormat'   : [[ 236, 244, 'none'], [ 232, 239, 'none']]
				\ , 'FileEncoding' : [[ 236, 244, 'none'], [ 232, 239, 'none']]
				\ , 'Separator'    : [[ 236, 242, 'none'], [ 232, 239, 'none']]
				\ , 'FileType'     : [[ 236, 248, 'none'], [ 232, 239, 'none']]
				\ , 'LinePercentS' : [[ 240, 236, 'none'], [ 234, 232, 'none']]
				\ , 'LinePercent'  : [[ 240, 250, 'none'], [ 234, 239, 'none']]
				\ , 'LineNumberS'  : [[ 252, 240, 'bold'], [ 234, 234, 'none']]
				\ , 'LineNumber'   : [[ 252, 236, 'bold'], [ 234, 244, 'none']]
				\ , 'LineColumn'   : [[ 252, 240, 'none'], [ 234, 239, 'none']]
			\ }
			\ , 'Insert': {
				\   'Mode'         : [[ 153,  23, 'bold'], [                 ]]
				\ , 'ModeS'        : [[ 153,  31, 'bold'], [                 ]]
				\ , 'Branch'       : [[  31, 117, 'none'], [                 ]]
				\ , 'BranchS'      : [[  31, 117, 'none'], [                 ]]
				\ , 'FileName'     : [[  31, 231, 'bold'], [                 ]]
				\ , 'FileNameS'    : [[  31,  24, 'bold'], [                 ]]
				\ , 'Error'        : [[  31, 202, 'bold'], [                 ]]
				\ , 'ModFlag'      : [[  31, 196, 'bold'], [                 ]]
				\ , 'BufFlag'      : [[  31,  75, 'none'], [                 ]]
				\ , 'FunctionName' : [[  24, 117, 'none'], [                 ]]
				\ , 'FileFormat'   : [[  24,  75, 'none'], [                 ]]
				\ , 'FileEncoding' : [[  24,  75, 'none'], [                 ]]
				\ , 'Separator'    : [[  24,  37, 'none'], [                 ]]
				\ , 'FileType'     : [[  24,  81, 'none'], [                 ]]
				\ , 'LinePercentS' : [[  31,  24, 'none'], [                 ]]
				\ , 'LinePercent'  : [[  31, 117, 'none'], [                 ]]
				\ , 'LineNumberS'  : [[ 117,  31, 'bold'], [                 ]]
				\ , 'LineNumber'   : [[ 117,  23, 'bold'], [                 ]]
				\ , 'LineColumn'   : [[ 117,  31, 'none'], [                 ]]
			\ }
		\ }
	" }}}
" }}}

" Statusline highlighting {{{
augroup StatusLineHighlight
	autocmd!

	let s:round_stl = 0

	au ColorScheme * call <SID>StatusLineColors(s:statuscolors)
	au BufEnter,BufWinEnter,WinEnter,CmdwinEnter,CursorHold,BufWritePost,InsertLeave * call <SID>StatusLine((exists('b:stl') ? b:stl : g:default_stl), 'Normal', 1)
	au BufLeave,BufWinLeave,WinLeave,CmdwinLeave * call <SID>StatusLine((exists('b:stl') ? b:stl : g:default_stl), 'Normal', 0)
	au InsertEnter,CursorHoldI * call <SID>StatusLine((exists('b:stl') ? b:stl : g:default_stl), 'Insert', 1)
augroup END
" }}}

augroup General " {{{
	autocmd!
	" Help file settings {{{
		function! s:SetupHelpWindow()
			wincmd L
			vertical resize 80
			setl nonumber winfixwidth colorcolumn=

			let b:stl = "#[Branch] HELP#[BranchS] [>] #[FileName]%<%t #[FileNameS][>>]%* %=#[LinePercentS][<<]#[LinePercent] %p%% " " Set custom statusline

			nnoremap <buffer> <Space> <C-]> " Space selects subject
			nnoremap <buffer> <BS>    <C-T> " Backspace to go back
		endfunction

		au FileType help au BufEnter,BufWinEnter <buffer> call <SID>SetupHelpWindow()
	" }}}
augroup END " }}}

" Status bar
set laststatus=2

