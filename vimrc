set nocompatible
filetype off " required by Vundle plumbing
set notimeout
set ttimeout
set ttimeoutlen=10

" Vundle
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
so ~/.vim/bundle.vim

let mapleader=","

set number
set ruler
syntax enable
set term=xterm-256color

" Set encoding
set encoding=utf-8

" Whitespace stuff
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab

" Searching
set hlsearch
set incsearch
set ignorecase
set smartcase

" Tab completion
set wildmode=list:longest,list:full
set wildignore+=*.o,*.obj,.git,*.rbc,*.class,.svn,vendor/gems/*,coverage/*

" Other options borrowed from Steve Losh
set listchars=tab:▸\ ,eol:¬,extends:❯,precedes:❮
set shell=/usr/local/bin/zsh
set showbreak=↪
set splitbelow
set splitright
set fillchars=diff:⣿
set noswapfile

" Keep search matches in the middle of the window and pulse the line when moving
" to them.
nnoremap n nzzzv
nnoremap N Nzzzv

" Window resizing
nnoremap <c-left> 5<c-w>>
nnoremap <c-right> 5<c-w><

" Heresy
inoremap <c-a> <esc>I
inoremap <c-e> <esc>A

" Easier to type, and I never use the default behavior.
noremap H ^
noremap L g_

" Space to toggle folds.
nnoremap <Space> za
vnoremap <Space> za

" Swap case
nnoremap U gUiw
inoremap <C-u> <esc>gUiwea"

" Substitute
nnoremap <leader>s :%s//<left>

" Ack
map <leader>a :Ack 

" Emacs bindings in command line mode
cnoremap <c-a> <home>
cnoremap <c-e> <end>

" Yankring
nnoremap <silent> <F5> :YRShow<cr>

" Select (charwise) the contents of the current line, excluding indentation.
" Great for pasting Python lines into REPLs.
nnoremap vv ^vg_

" Calculator
inoremap <C-B> <C-O>yiW<End>=<C-R>=<C-R>0<CR>

" Sudo to write
cmap w!! w !sudo tee % >/dev/null

" Without setting this, ZoomWin restores windows in a way that causes
" equalalways behavior to be triggered the next time CommandT is used.
" This is likely a bludgeon to solve some other issue, but it works
set noequalalways

" ZoomWin configuration
map <Leader>; :ZoomWin<CR>

" Turn on jshint errors by default
let g:JSLintHighlightErrorLine = 1

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
set background=light
color hemisu

" Directories for swp files
set backupdir=~/.vim/backup
set directory=~/.vim/backup

" % to bounce from do to end etc.
runtime! macros/matchit.vim

" Show (partial) command in the status line
set showcmd

" Adjust viewports to the same size
map <Leader>= <C-w>=
imap <Leader>= <Esc><C-w>=

" Don't beep
set visualbell

" Turn on jshint errors by default
let g:JSLintHighlightErrorLine = 1

" Highlight cursor line
set cursorline

" Mappings
map <Leader>c :Rcontroller<cr>
map <Leader>m :Rmodel<cr>

imap <C-l> <Space>=><Space>
map <C-t> <esc>:tabnew<CR>

" Gist.vim
let g:gist_clip_command = 'pbcopy'
let g:gist_detect_filetype = 1
let g:gist_show_privates = 1
let g:gist_open_browser_after_post = 1

" Remove whitespaces
map <f6> :FixWhitespace<CR>

" Leader Leader to switch between files
nnoremap <leader><leader> <c-^>

" FuzzyFinder
nmap <leader>f :FufFileWithCurrentBufferDir<CR>
" nmap <leader>b :FufBuffer<CR>

" Unset the last search pattern
nnoremap <Leader><space> :noh<CR>

" Close QuickFix window in normal mode
nnoremap <Leader>k :ccl<CR>

" css-colors with SCSS files
autocmd FileType sass,scss,stylus syn cluster sassCssAttributes add=@cssColors

" NERDTree configuration
let NERDTreeIgnore=['\.pyc$', '\.rbc$', '\~$']
let NERDTreeDirArrows = 1
let NERDTreeMouseMode = 3
map <Leader>n :NERDTreeToggle<CR>

" CTags & Tagbar
let g:tagbar_ctags_bin='/usr/local/bin/ctags'
let g:tagbar_width=26
noremap <silent> <Leader>y :TagbarToggle<cr>
noremap <silent> <Leader>gt <C-]>

" Statusline setup
set statusline+=%f\                                " modified flag
set statusline+=%{fugitive#statusline()}           " git branch
set statusline+=%m                                 " modified flag
set statusline+=%r                                 " read-only flag
set statusline+=%=                                 " left/right separator
set statusline+=%{StatuslineCurrentHighlight()}\ " current highlight
set statusline+=%c:                                " cursor column
set statusline+=%l/%L                              " cursor line/total lines
set laststatus=2

" Return the syntax highlight group under the cursor ''
function! StatuslineCurrentHighlight()
    let name = synIDattr(synID(line('.'),col('.'),1),'name')
    if name == ''
        return ''
    else
        return '[' . name . ']'
    endif
endfunction

" Reselect visual block after indent/outdent
vnoremap < <gv
vnoremap > >gv

" Improve up/down movement on wrapped lines
nnoremap j gj
nnoremap k gk

" CtrlP
let g:ctrlp_extensions = ["tag"]
let g:ctrlp_match_window_reversed = 0
let g:ctrlp_map = '<c-f>'
let g:CtrlPp_max_height = 100
map <leader>gv :CtrlP app/views<cr>
map <leader>gc :CtrlP app/controllers<cr>
map <leader>gm :CtrlP app/models<cr>
map <leader>gl :CtrlP lib<cr>
map <leader>b :CtrlPBuffer<cr>
map <leader>f :CtrlPMRU<cr>
map <leader>F :CtrlP %%<cr>
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\.git$\|\.hg$\|\.svn$\|\coverage$\|\.bundler$',
  \ 'file': '\tags$\|\.rvmrc$\|\.rbenv$\|\.powrc$\|\.rspec$',
  \ 'link': 'some_bad_symbolic_links',
  \ }
let g:ctrlp_prompt_mappings = {
      \ 'PrtSelectMove("j")':   ['<c-j>', '<down>', '<s-tab>'],
      \ 'PrtSelectMove("k")':   ['<c-k>', '<up>', '<tab>'],
      \ 'PrtHistory(-1)':       ['<c-n>'],
      \ 'PrtHistory(1)':        ['<c-p>'],
      \ 'ToggleFocus()':        ['<c-tab>'],
      \ }

" Scratch
command! ScratchToggle call ScratchToggle()

function! ScratchToggle() " {{{
  if exists("w:is_scratch_window")
    unlet w:is_scratch_window
    exec "q"
  else
    exec "normal! :Sscratch\<cr>\<C-W>J:resize 13\<cr>"
    let w:is_scratch_window = 1
  endif
endfunction " }}}

nnoremap <silent> <leader><tab> :ScratchToggle<cr>

" Save and return to normal mode on FocusLost
au FocusLost * :silent! wall                 " Save on FocusLost
au FocusLost * call feedkeys("\<C-\>\<C-n>") " Return to normal mode on FocustLost

" disable arrow keys for the moment
inoremap  <Up>     <NOP>
inoremap  <Down>   <NOP>
inoremap  <Left>   <NOP>
inoremap  <Right>  <NOP>
noremap   <Up>     <NOP>
noremap   <Down>   <NOP>
noremap   <Left>   <NOP>
noremap   <Right>  <NOP>
