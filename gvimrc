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
  set guifont=Menlo:h14

  " Default gui color scheme
  set background=dark
  colorscheme solarized

  " Automatically resize splits when resizing MacVim window
  autocmd VimResized * wincmd =


  " Command-T for CtrlP
  macmenu &File.New\ Tab key=<D-T>
  map <D-t> :CtrlP<CR>
  imap <D-t> <Esc>:CtrlP<CR>

endif

