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
  colorscheme Tomorrow-Night

  " Automatically resize splits when resizing MacVim window
  autocmd VimResized * wincmd =


  " Command-T for CtrlP
  macmenu &File.New\ Tab key=<D-T>
  map <D-t> :CtrlP<CR>
  imap <D-t> <Esc>:CtrlP<CR>

  " Project Tree
  if exists("loaded_nerd_tree")
    autocmd VimEnter * call s:CdIfDirectory(expand("<amatch>"))
    autocmd FocusGained * call s:UpdateNERDTree()
    autocmd WinEnter * call s:CloseIfOnlyNerdTreeLeft()
  endif

  " Close all open buffers on entering a window if the only
  " buffer that's left is the NERDTree buffer
  function s:CloseIfOnlyNerdTreeLeft()
    if exists("t:NERDTreeBufName")
      if bufwinnr(t:NERDTreeBufName) != -1
        if winnr("$") == 1
          q
        endif
      endif
    endif
  endfunction

  " If the parameter is a directory, cd into it
  function s:CdIfDirectory(directory)
    let explicitDirectory = isdirectory(a:directory)
    let directory = explicitDirectory || empty(a:directory)

    if explicitDirectory
      exe "cd " . fnameescape(a:directory)
    endif

    " Allows reading from stdin
    " ex: git diff | mvim -R -
    if strlen(a:directory) == 0 
      return
    endif

    if directory
      NERDTree
      wincmd p
      bd
    endif

    if explicitDirectory
      wincmd p
    endif
  endfunction

  " NERDTree utility function
  function s:UpdateNERDTree(...)
    let stay = 0

    if(exists("a:1"))
      let stay = a:1
    end

    if exists("t:NERDTreeBufName")
      let nr = bufwinnr(t:NERDTreeBufName)
      if nr != -1
        exe nr . "wincmd w"
        exe substitute(mapcheck("R"), "<CR>", "", "")
        if !stay
          wincmd p
        end
      endif
    endif

    if exists(":CommandTFlush") == 2
      CommandTFlush
    endif
  endfunction

endif

