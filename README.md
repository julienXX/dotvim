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

Remember to run :BundleInstall to tell Vundle to grab all plugins

Mostly inspired by jhchabran vimfiles https://github.com/jhchabran/vimfiles
