#!/bin/bash
RED='\e[31m'
GREEN='\e[32m'
YELLOW='\e[33m'
PURPLE='\e[35m'
NORMAL='\e[0m'
BLUE='\e[34m'
WELCOME="¡Bienvenido, este script escrito en bash realizará paso a paso \
la compilación y instalación de (QTILE WM) con soporte para (Wayland) \
en su carpeta de usuario personal(Home) y copiará el \
ejecutable (qtile) a (~/.local/bin)!"
FOLDERQTILE="qtile_venv"

figlet -f smslant  "BUILD QTILE WAYLAND"
echo -e "${BLUE}${WELCOME}${NORMAL}"
echo -n -e "${YELLOW}¿Desea continuar con la instalación? : (y/n)${NORMAL} "
read confirmation
if [ $confirmation = "y" ]
then
	cd ~
	python3 -m venv ${FOLDERQTILE}
	cd  ~/${FOLDERQTILE}
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
	cd ~/${FOLDERQTILE}/qtile
	# install Qtile
	pip3 install --config-setting backend=wayland . 
	cd ~/${FOLDERQTILE}
	cp bin/qtile ~/.local/bin
	pip3 install psutil
	pip3 install dbus-next
	pip3 install pulsectl-asyncio
	pip3 install iwlib
	echo -e "${GREEN}Instalación terminada:)${NORMAL}"
fi
