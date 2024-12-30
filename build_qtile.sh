#!/bin/bash
RED='\e[31m'
GREEN='\e[32m'
YELLOW='\e[33m'
PURPLE='\e[35m'
NORMAL='\e[0m'
BLUE='\e[34m'
WELCOME="Welcome,this bash script will step by step compile and install QTILE WM\n\
with Wayland or X11 support into your home user folder and copy the qtile executable to ~/.local/bin!"
FOLDERQTILE="qtile_env"

# list opts
function usage {
    printf "Usage:\n"
    printf " -h				Display this help message.\n"
    printf " -f <folder env>		example: qtile_env .\n"
    printf " -b <backend>			x11 / wayland.\n"
    exit 0
}

# opts
while getopts hf:b: opt
do
    case "${opt}" in
	 h) usage 
	   ;;
	 f) FOLDERQTILE=${OPTARG}
	   ;;
         b) if [ ${OPTARG} = "wayland" ] ; then BACKEND="wayland" ; else BACKEND="x11" ; fi
	   ;;
	 ?) echo "script usage [-f folder env] [-b backend] [-h]" >&2
	   exit 1
	   ;;
    esac
done

if [ -z  "$BACKEND" ]; then
    echo "You have not introduced the backend argument"
    exit 1
fi
echo -e "${BLUE}${WELCOME}${NORMAL}"
echo -n -e "${YELLOW}Do you want to continue with the installation ? [y/n*]\n${NORMAL}"
read -p "> " confirmation
if [ $confirmation = "y" ]
then	
	echo -e "${GREEN}starting installation...${NORMAL}"
	sleep 1
	cd ~
	python3 -m venv ${FOLDERQTILE}
	cd  ~/${FOLDERQTILE}
	git clone https://github.com/qtile/qtile.git
	case ${BACKEND} in
	    x11)		
	    # X11 Backend
	    bin/pip3 install xcffib
	    source bin/activate
	    cd ~/${FOLDERQTILE}/qtile
	    # install qtile x11 backend
	    pip3 install . 
	    ;;
	    wayland)
	    # Wayland Backend
	    git clone https://github.com/flacjacket/pywayland.git
	    git clone https://github.com/flacjacket/pywlroots.git
	    git clone https://github.com/sde1000/python-xkbcommon.git	
	    # install pywayland and pywlroots 
	    # build qtile and pywlroots with wlroots 0.17
	    export CFLAGS="$CFLAGS -I/usr/include/wlroots0.17"
	    export LDFLAGS="$LDFLAGS -L/usr/lib/wlroots0.17"
	    bin/pip3 install python-xkbcommon/.
	    bin/pip3 install pywayland/.
	    bin/pip3 install pywlroots/.
	    source bin/activate
	    cd ~/${FOLDERQTILE}/qtile
	    # install qtile wayland backend
	    pip3 install --config-setting backend=wayland . 
	    ;;
	esac
	cd ~/${FOLDERQTILE}
	cp bin/qtile ~/.local/bin
	pip3 install psutil
	pip3 install dbus-fast
	pip3 install pulsectl-asyncio
	pip3 install iwlib
	echo -e "${GREEN}Installation completed :)${NORMAL}"
fi
