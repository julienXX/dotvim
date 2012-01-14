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
set list
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

" Ack for the last search.
nnoremap <silent> <leader>? :execute "Ack! '" . substitute(substitute(substitute(@/, "\\\\<", "\\\\b", ""), "\\\\>", "\\\\b", ""), "\\\\v", "", "") . "'"<CR>

" Space to toggle folds.
nnoremap <Space> za
vnoremap <Space> za

" Shell
function! s:ExecuteInShell(command) " {{{
    let command = join(map(split(a:command), 'expand(v:val)'))
    let winnr = bufwinnr('^' . command . '$')
    silent! execute  winnr < 0 ? 'botright vnew ' . fnameescape(command) : winnr . 'wincmd w'
    setlocal buftype=nowrite bufhidden=wipe nobuflisted noswapfile nowrap nonumber
    echo 'Execute ' . command . '...'
    silent! execute 'silent %!'. command
    silent! redraw
    silent! execute 'au BufUnload <buffer> execute bufwinnr(' . bufnr('#') . ') . ''wincmd w'''
    silent! execute 'nnoremap <silent> <buffer> <LocalLeader>r :call <SID>ExecuteInShell(''' . command . ''')<CR>:AnsiEsc<CR>'
    silent! execute 'nnoremap <silent> <buffer> q :q<CR>'
    silent! execute 'AnsiEsc'
    echo 'Shell command ' . command . ' executed.'
endfunction " }}}
command! -complete=shellcmd -nargs=+ Shell call s:ExecuteInShell(<q-args>)
nnoremap <leader>! :Shell

" Change case
nnoremap <C-u> gUiw
inoremap <C-u> <esc>gUiwea

" Substitute
nnoremap <leader>s :%s//<left>

" Emacs bindings in command line mode
cnoremap <c-a> <home>
cnoremap <c-e> <end>

" Yankring
nnoremap <silent> <F5> :YRShow<cr>

" Formatting, TextMate-style
nnoremap Q gqip

" Easier linewise reselection
nnoremap <leader>V V`]

" Select (charwise) the contents of the current line, excluding indentation.
" Great for pasting Python lines into REPLs.
nnoremap vv ^vg_

" Calculator
inoremap <C-B> <C-O>yiW<End>=<C-R>=<C-R>0<CR>

" Sudo to write
cmap w!! w !sudo tee % >/dev/null

" Ack motions
" Motions to Ack for things.  Works with pretty much everything, including:
"   w, W, e, E, b, B, t*, f*, i*, a*, and custom text objects
" Awesome.
"
" Note: If the text covered by a motion contains a newline it won't work.  Ack
" searches line-by-line.

nnoremap <silent> \a :set opfunc=<SID>AckMotion<CR>g@
xnoremap <silent> \a :<C-U>call <SID>AckMotion(visualmode())<CR>

function! s:CopyMotionForType(type)
    if a:type ==# 'v'
        silent execute "normal! `<" . a:type . "`>y"
    elseif a:type ==# 'char'
        silent execute "normal! `[v`]y"
    endif
endfunction

function! s:AckMotion(type) abort
    let reg_save = @@

    call s:CopyMotionForType(a:type)

    execute "normal! :Ack! --literal " . shellescape(@@) . "\<cr>"

    let @@ = reg_save
endfunction

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
set background=dark
color solarized

" Directories for swp files
set backupdir=~/.vim/backup
set directory=~/.vim/backup

" % to bounce from do to end etc.
runtime! macros/matchit.vim

" Show (partial) command in the status line
set showcmd

" Ack
map <leader>F :Ack<space>

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
map <Leader>c :Rcontroller
map <Leader>m :Rmodel

imap <C-l> <Space>=><Space>
map <C-t> <esc>:tabnew<CR>
map <C-x> <C-w>c

" Gist.vim
let g:gist_clip_command = 'pbcopy'
let g:gist_detect_filetype = 1
let g:gist_show_privates = 1
let g:gist_open_browser_after_post = 1

" Remove whitespaces
map <f6> :FixWhitespace<CR>

" Status bar
set laststatus=2

" Leader Leader to switch between files
nnoremap <leader><leader> <c-^>

" Running tests
function! RunTests(filename)
  " Write the file and run tests for the given filename
  :w
  :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
  if match(a:filename, '\.feature$') != -1
    exec ":!bundle exec cucumber " . a:filename
  else
    if filereadable("script/test")
      exec ":!script/test " . a:filename
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
  call RunTestFile(":" . spec_line_number)
endfunction

map <leader>t :call RunTestFile()<cr>
map <leader>T :call RunNearestTest()<cr>
map <leader>a :call RunTests('')<cr>

" Restart server
map <leader>R :!touch tmp/restart.txt<cr>

" FuzzyFinder
nmap <leader>f :FufFileWithCurrentBufferDir<CR>
nmap <leader>b :FufBuffer<CR>

" Refresh ctags
nmap <leader>ct :!/usr/local/bin/ctags -R --extra=+f .<cr>

" Unset the last search pattern by hitting return again
nnoremap <CR> :noh<CR><CR>

" css-colors with SCSS files
autocmd FileType sass,scss,stylus syn cluster sassCssAttributes add=@cssColors

" NERDTree configuration
let NERDTreeIgnore=['\.pyc$', '\.rbc$', '\~$']
let NERDTreeDirArrows = 1
let NERDTreeMouseMode = 3
map <Leader>n :NERDTreeToggle<CR>

" Tagbar
let g:tagbar_ctags_bin='/usr/local/bin/ctags'
let g:tagbar_width=26
noremap <silent> <Leader>y :TagbarToggle<cr>

let g:Powerline_symbols = 'fancy'
