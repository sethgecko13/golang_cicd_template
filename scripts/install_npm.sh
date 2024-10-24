#!/bin/bash
SYSTEM=$(uname)
if [[ $SYSTEM == "Linux" ]];then
	sudo snap install node --classic --channel=19
elif [[ $SYSTEM == "Darwin" ]]; then
    brew install npm
else 
    echo "Unable to determine operating systm"
    exit 1
fi