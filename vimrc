" .vimrc
" Author: Julien Blanchard <julien@sideburns.eu>
" Source: https://github.com/julienXX/dotvim/blob/master/vimrc
"
" This is the vimrc I built, stoling pieces here and there but mostly
" from Steve Losh & Gary Bernhardt.


" Vundle {{{

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
so ~/.vim/bundle.vim

" }}}

" General options {{{

let mapleader=","
let maplocalleader=";"
set nocompatible
set notimeout
set ttimeout
set ttimeoutlen=10
" allow unsaved background buffers and remember marks/undo for them
set hidden
set history=10000
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2
set autoindent
set number
set showmatch
set incsearch
set hlsearch
set ignorecase smartcase
set cursorline
set cmdheight=2
set switchbuf=useopen
set numberwidth=5
set showtabline=2
set winwidth=79
set shell=bash
set clipboard=unnamed
" Prevent Vim from clobbering the scrollback buffer. See
" http://www.shallowsky.com/linux/noaltscreen.html
set t_ti= t_te=
" keep more context when scrolling off the end of a buffer
set scrolloff=3
" split location
set splitbelow
set splitright
set noswapfile
" allow backspacing over everything in insert mode
set backspace=indent,eol,start
" display incomplete commands
set showcmd
syntax on
filetype plugin indent on
set foldmethod=marker
set wildmode=list:longest,list:full
set wildignore+=*.o,*.obj,.git,*.rbc,*.class,.svn,vendor/gems/*,coverage/*
set wildmenu
" Don't beep
set visualbell
" Save and return to normal mode on FocusLost
au FocusLost * :silent! wall                 " Save on FocusLost
au FocusLost * call feedkeys("\<C-\>\<C-n>") " Return to normal mode on FocustLost
" Remember last location in file
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal g'\"" | endif
endif

" }}}

" Colors {{{

set t_Co=256 " 256 colors
set background=dark
color solarized

" }}}

" Status line {{{

set statusline=%<%f\ (%{&ft})\ %-4(%m%)%=%-19(%3l,%02c%03V%)
set laststatus=2
set showcmd
set showmode
set cmdheight=1

" }}}

" Misc key mappings {{{

" Leader Leader to switch between files
nnoremap <leader><leader> <c-^>
" Unset the last search pattern
:nnoremap <CR> :nohlsearch<cr>
" Close QuickFix window in normal mode
nnoremap <Leader>k :ccl<CR>
" Reselect visual block after indent/outdent
vnoremap < <gv
vnoremap > >gv
" Improve up/down movement on wrapped lines
nnoremap j gj
nnoremap k gk
map <leader>y "*y
" Insert a hash rocket with <c-l>
imap <c-l> <space>=><space>
" Can't be bothered to understand ESC vs <c-c> in insert mode
imap <c-c> <esc>
" Clear the search buffer when hitting return
:nnoremap <CR> :nohlsearch<cr>
nnoremap <leader><leader> <c-^>
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
map <localleader>a :Ack 
" Emacs bindings in command line mode
cnoremap <c-a> <home>
cnoremap <c-e> <end>
" Sudo to write
cmap w!! w !sudo tee % >/dev/null
" Adjust viewports to the same size
map <Leader>= <C-w>=
imap <Leader>= <Esc><C-w>=

" }}}

" Navigation {{{

" Disable arrow keys
map <Left> :echo "no!"<cr>
map <Right> :echo "no!"<cr>
map <Up> :echo "no!"<cr>
map <Down> :echo "no!"<cr>

" Move around splits with <c-hjkl>
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

" Tabs navigation
map <localleader><tab> :tabnext<cr>
map <C-t> <esc>:tabnew<CR>

" CTags
noremap <silent> <Leader>gt <C-]>

" }}}

" Tab key {{{

function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction
inoremap <tab> <c-r>=InsertTabWrapper()<cr>
inoremap <s-tab> <c-n>

" }}}

" Open in currentdirectory {{{

cnoremap %% <C-R>=expand('%:h').'/'<cr>
map <leader>e :edit %%
map <leader>v :view %%

" }}}

" Rename current file {{{

function! RenameFile()
    let old_name = expand('%')
    let new_name = input('New file name: ', expand('%'), 'file')
    if new_name != '' && new_name != old_name
        exec ':saveas ' . new_name
        exec ':silent !rm ' . old_name
        redraw!
    endif
endfunction
map <localleader>r :call RenameFile()<cr>

" }}}

" Run tests {{{

function! RunTests(filename)
    " Write the file and run tests for the given filename
    :w
    :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
    :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
    :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
    :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
    :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
    :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
    if match(a:filename, '\.feature$') != -1
        exec ":!script/features " . a:filename
    else
        if filereadable("script/test")
            exec ":!script/test " . a:filename
        elseif filereadable("script/console")
            exec ":!bundle exec spec --color " . a:filename
        elseif filereadable("Gemfile")
            exec ":!bundle exec rspec --color " . a:filename
        else
            exec ":!rspec --color " . a:filename
        end
    end
endfunction

function! SetTestFile()
    " Set the spec file that tests will be run for.
    let t:grb_test_file=@%
endfunction

function! RunTestFile(...)
    if a:0
        let command_suffix = a:1
    else
        let command_suffix = ""
    endif

    " Run the tests for the previously-marked file.
    let in_test_file = match(expand("%"), '\(.feature\|_spec.rb\)$') != -1
    if in_test_file
        call SetTestFile()
    elseif !exists("t:grb_test_file")
        return
    end
    call RunTests(t:grb_test_file . command_suffix)
endfunction

function! RunNearestTest()
    let spec_line_number = line('.')
    call RunTestFile(":" . spec_line_number . " -b")
endfunction

map <leader>t :call RunTestFile()<cr>
map <leader>T :call RunNearestTest()<cr>
map <leader>a :call RunTests('spec')<cr>

" }}}

" OpenChangedFiles COMMAND {{{

" Open a split for each dirty file in git
function! OpenChangedFiles()
  only " Close all windows, unless they're modified
  let status = system('git status -s | grep "^ \?\(M\|A\)" | cut -d " " -f 3')
  let filenames = split(status, "\n")
  exec "edit " . filenames[0]
  for filename in filenames[1:]
    exec "sp " . filename
  endfor
endfunction
command! OpenChangedFiles :call OpenChangedFiles()

" }}}

" InsertTime COMMAND {{{

" Insert the current time
command! InsertTime :normal a<c-r>=strftime('%F %H:%M:%S.0 %z')<cr>

" }}}

" Syntax {{{

" Rainbow
au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces

" Thorfile, Rakefile, Vagrantfile and Gemfile are Ruby
au BufRead,BufNewFile {Gemfile,Rakefile,Vagrantfile,Thorfile,config.ru} set ft=ruby

" add json syntax highlighting
au BufNewFile,BufRead *.json set ft=javascript

au BufRead,BufNewFile *.txt call s:setupWrapping()

" Less CSS
au BufRead,BufNewFile *.less setfiletype less

" css-colors with SCSS files
autocmd FileType sass,scss,stylus syn cluster sassCssAttributes add=@cssColors

" }}}

" Plugins configuration & mappings {{{

" ZoomWin configuration
" Without setting this, ZoomWin restores windows in a way that causes
" equalalways behavior to be triggered the next time CommandT is used.
" This is likely a bludgeon to solve some other issue, but it works
set noequalalways
map <Leader>; :ZoomWin<CR>

" % to bounce from do to end etc.
runtime! macros/matchit.vim

" Rails.vim Mappings
map <Leader>c :Rcontroller<cr>
map <Leader>m :Rmodel<cr>

" Gist.vim
let g:gist_clip_command = 'pbcopy'
let g:gist_detect_filetype = 1
let g:gist_show_privates = 1
let g:gist_open_browser_after_post = 1

" Remove whitespaces
map <f6> :FixWhitespace<CR>

" NERDTree configuration
let NERDTreeIgnore=['\.pyc$', '\.rbc$', '\~$']
let NERDTreeDirArrows = 1
let NERDTreeMouseMode = 3
map <Leader>n :NERDTreeToggle<CR>

" CtrlP
let g:ctrlp_extensions = ["tag"]
let g:ctrlp_match_window_reversed = 0
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:Ctrlp_max_height = 100
let g:ctrlp_switch_buffer = 2
let g:ctrlp_mruf_relative = 1
map <leader>gv :CtrlP app/views<cr>
map <leader>gc :CtrlP app/controllers<cr>
map <leader>gm :CtrlP app/models<cr>
map <leader>gl :CtrlP lib<cr>
map <leader>b :CtrlPBuffer<cr>
map <leader>f :CtrlPMRU<cr>
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

" Command-T
map <leader>gv :CommandTFlush<cr>\|:CommandT app/views<cr>
map <leader>gc :CommandTFlush<cr>\|:CommandT app/controllers<cr>
map <leader>gm :CommandTFlush<cr>\|:CommandT app/models<cr>
map <leader>gl :CommandTFlush<cr>\|:CommandT lib<cr>
map <leader>f :CommandTFlush<cr>\|:CommandT<cr>
map <leader>b :CommandTFlush<cr>\|:CommandTBuffer<cr>
map <leader>F :CommandTFlush<cr>\|:CommandT %%<cr>

let g:CommandTMaxHeight = 15
let g:CommandTCancelMap = '<Esc>'

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

" Easymotion
let g:EasyMotion_leader_key = '<localleader>'

" }}}

