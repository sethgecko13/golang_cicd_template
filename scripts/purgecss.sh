#!/bin/bash
PCSS=$(which purgecss |wc -l)
if [[ $PCSS == "0" ]]; then
	echo $PCSS
	echo "ERROR: install purgecss"
	exit 1
fi
TMP=$(mktemp -d)
CSS=$TMP/css
mkdir -p $TMPCSS
CSS=$(ls css/*  | sort | tail -1)
purgecss --css $CSS --content www/*.html templates/*.html --output $TMPCSS
if [[ $RESULT1 -gt 0 ]];then
	echo "Issues with css"
	diff "$CSS" "${TMP}/${CSS}"
	exit 1
fi
