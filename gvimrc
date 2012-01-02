if has("gui_macvim")
  " Fullscreen takes up entire screen
  set fuoptions=maxhorz,maxvert

  " Command-Return for fullscreen
  macmenu Window.Toggle\ Full\ Screen\ Mode key=<D-CR>

  " Start without the toolbar
  set guioptions-=T

  " Start without the scrollbars
  set guioptions-=r
  set guioptions-=L

  " Default gui font
  set guifont=Menlo:h13

  " Default gui color scheme
  set background=dark
  colorscheme solarized

  " Automatically resize splits when resizing MacVim window
  autocmd VimResized * wincmd =

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

  " Command h to disable search highlight
  map <C-h> :nohl<CR>

endif

