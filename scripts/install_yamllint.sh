#!/bin/bash
SYSTEM=$(uname)
if [[ $SYSTEM == "Linux" ]];then
	sudo apt-get install -y yamllint
elif [[ $SYSTEM == "Darwin" ]]; then
    brew install yamllint
else 
    echo "Unable to determine operating system"
    exit 1
fi