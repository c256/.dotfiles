#!/bin/bash

jpg=$1
png=$2

if [ "$jpg" = "" -o "$png" = "" ]; then
   echo "Usage: make-face <JPG-FILE> <BASE64-FILE>"
   exit
fi

quant=16
found=false
tmp=/tmp/make-face.$$.tmp

while [ "$found" = "false" ]; do
    echo -n "Trying quantization $quant ($jpg)..."
    djpeg "$jpg"\
	| ppmnorm\
	| pnmscale -width 48 -height 48\
	| ppmquant $quant\
	| pnmtopng\
	| mimencode > $tmp
    size=`ls -l $tmp | awk '{ print $5; }'`
    if [ $size -lt 999 ]; then
	echo -n "Face:" > "$png"
	for i in `cat $tmp`; do
	    echo -n " " >> "$png"
	    echo "$i" >> "$png"
	done
	rm $tmp
	found=true
	echo "done"
    else
	quant=`expr $quant - 2`
	echo "too big ($size)"
    fi
done

    
