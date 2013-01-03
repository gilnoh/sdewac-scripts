#!/bin/bash

if [[ "$1" == "" ]]; then 
	echo "Needs one number (partial file number)"
	exit
fi

perl mrecover.pl ../parts/sdewac_part$1.utf8.txt.conll ../parts-intermediate/sdewac_part$1.mstparsed.utf8.txt.conll > ../parts-mstparsed/sdewac_part$1.mstparsed.utf8.conll 2> errlog 



 

