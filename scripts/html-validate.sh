#!/bin/bash
RESULT=$(npx html-validate "templates/*.html" "www/*/*.html" "www/*/*/*.html" 2>&1 | wc -l)
if [[ $RESULT -gt 0 ]];then 
	echo "html-validate failed"
    npx html-validate "templates/*.html" "www/*/*.html" "www/*/*/*.html"
	exit 1
fi
