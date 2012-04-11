Installation
============

Clone the repo:
`$ git clone https://github.com/julienXX/dotvim.git ~/.vim`

Create subdirectories:
`$ mkdir ~/.vim/bundle`
`$ mkdir ~/.vim/backup`

Then install Vundle:
`$ git clone http://github.com/gmarik/vundle.git ~/.vim/bundle/vundle`

Make sure vim finds the vimrc file by either symlinking it:
`$ ln -s ~/.vim/vimrc ~/.vimrc`

Run :BundleInstall to tell Vundle to bundle all plugins

Mostly inspired by these people vimfiles:

* Jean Hadrien Chabran https://github.com/jhchabran/vimfiles
* Steve Losh https://github.com/sjl/dotfiles
* Gary Bernhardt https://github.com/garybernhardt/dotfiles
