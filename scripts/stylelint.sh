#!/bin/bash
RESULT=$(npx stylelint "css/*.css" 2>&1 | wc -l)
if [[ $RESULT -gt 0 ]];then 
echo $RESULT
	echo "stylelint failed"
	npx stylelint "css/*.css"
	exit 1
fi
