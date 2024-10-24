#!/bin/bash
CURRENT=$(curl --silent https://go.dev/VERSION?m=text | head -1)
curl -O https://dl.google.com/go/${CURRENT}.darwin-arm64.pkg
open $CURRENT.darwin-arm64.pkg
