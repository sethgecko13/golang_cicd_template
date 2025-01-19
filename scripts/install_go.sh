#!/bin/bash
## Do this because of github codespaces
unset GOPATH
CURRENT=$(curl --silent https://go.dev/VERSION?m=text | head -1)
INSTALLED=$(go version | awk '{print $3}')
if [[ $CURRENT != $INSTALLED ]]; then
	SYSTEM=$(uname)
	if [[ $SYSTEM == "Linux" ]]; then
		echo "Current: $CURRENT"
		echo "Installed: $INSTALLED"
		echo "Upgrade Golang to $CURRENT"
		wget -q https://go.dev/dl/$CURRENT.linux-amd64.tar.gz
		sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf $CURRENT.linux-amd64.tar.gz
	fi
	if [[ $SYSTEM == "Darwin" ]]; then
		echo "Current: $CURRENT"
		echo "Installed: $INSTALLED"
		echo "Upgrade Golang to $CURRENT"
		scripts/download_go_mac.sh
	fi
fi
INSTALLED=$(go version | awk '{print $3}')
if [[ $CURRENT != $INSTALLED ]]; then
	echo "Current: $CURRENT"
	echo "Installed: $INSTALLED"
	exit 1
fi
