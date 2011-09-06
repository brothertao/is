#!/bin/sh
if [ ! -f ~/.vimrc ]
then
	cp _vimrc ~/.vimrc
else
	echo -n "the file .vimrc has exist,do you want to overwrite it?[Y/n]:"
	read OR
	if [ "n" != "$OR" ]
	then  cp -f _vimrc ~/.vimrc
	else exit 0
	fi
fi

if [ -d ~/.vim ]
then
	cp -r vimfiles ~/.vim
else
	rm -rf ~/.vim
	cp -r vimfiles ~/.vim
fi
