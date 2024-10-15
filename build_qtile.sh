#!/bin/bash
RED='\e[31m'
GREEN='\e[32m'
YELLOW='\e[33m'
PURPLE='\e[35m'
NORMAL='\e[0m'
BLUE='\e[34m'
WELCOME="Welcome, this bash script will step by step compile and install (QTILE WM) with support for (Wayland) into your personal user folder (Home) and copy the (qtile) executable to (~/.local/bin)!"

echo -e "${BLUE}${WELCOME}${NORMAL}"
echo -n -e "${YELLOW}Do you want to continue with the installation? : (y/n)${NORMAL} "
read confirmation
if [ $confirmation = "y" ]
then
    cd ~ 	
    echo -n -e "${YELLOW}Enter the folder where to install qtile as virtualenv : ${NORMAL} "
    read FOLDERENV
    echo -n -e "${YELLOW}will be installed in this folder '$HOME/${FOLDERENV}'${NORMAL} "
    echo -n -e "${YELLOW}You're sure? : (y/n)${NORMAL} "
    read confirmation
    if [ $confirmation = "y" ]
    then
	python3 -m venv ${FOLDERENV}
	cd  ~/${FOLDERENV}
	git clone https://github.com/qtile/qtile.git
	git clone https://github.com/flacjacket/pywayland.git
	git clone https://github.com/flacjacket/pywlroots.git
	git clone https://github.com/sde1000/python-xkbcommon.git	
	# install pywayland and pywlroots 
	# build qtile and pywlroots with wlroots 0.17
	export CFLAGS="$CFLAGS -I/usr/include/wlroots0.17"
	export LDFLAGS="$LDFLAGS -L/usr/lib/wlroots0.17"
	bin/pip3 install xcffib
	bin/pip3 install python-xkbcommon/.
	bin/pip3 install pywayland/.
	bin/pip3 install pywlroots/.
	source bin/activate
	cd ~/${FOLDERENV}/qtile
	# install Qtile
	pip3 install --config-setting backend=wayland . 
	cd ~/${FOLDERENV}
	mkdir -p  ~/.local/bin
	cp bin/qtile ~/.local/bin
	pip3 install psutil
	pip3 install dbus-next
	pip3 install pulsectl-asyncio
	pip3 install iwlib
 	echo -e "${GREEN}installation completed :)${NORMAL}"
    else  
 	echo -e "${RED}installation cancelled${NORMAL}"
    fi    
else
    echo -e "${RED}installation cancelled${NORMAL}"	    
fi
