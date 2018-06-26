#!/bin/bash
##############################################################################################################
# This script get a PDF file as first argument, and generate separate PDFs according to a barcode inside,
# Each page that has a barcode in start a new set of pages in generated pdfs.
# 
# The script need these utilities : pdftoppm, zbarimg and pdftk
# To install then in Debian/Ubuntu/Mint - type : sudo apt install pdftk zbar-tools poppler-utils
#
# Written by Yedidia Klein 2018 - Yedidia@openapp.co.il
# Use it in your own risk.
# License : GPL
#
##############################################################################################################

if [ "$#" -lt 1 ]; then
	echo Usage: $0 pdf_file
	exit 1
fi

if [ ! -f $1 ]; then
	echo File $1 does not exist
	exit 1
fi

pdf=$1

# check that file is pdf and has more that 1 page
pages=`pdftk $pdf dump_data | grep NumberOfPages | cut -d: -f2 | sed 's/ //g;'`
if [ $? -ne 0 ]; then
	echo $1 is not a PDF file
	exit 1
fi

if [ $pages -lt 2 ]; then
	echo Your PDF has only one page.. nothing can be done...
	exit 1
fi

extraparams=$2

# first of all cut pdf to image per page in temp dir
mkdir $$
cp $pdf $$/in.pdf
cd $$
# generate images from pdf
pdftoppm -r 300 -png in.pdf image

# find if there are barcodes in each image
counter=1
start=1
oldbarcode=000
for f in *.png
do
	echo checking file $f
	# is there a barcode in file ?
	zbarimg -q --raw $extraparams $f >> /dev/null
	if [ $? -eq 0 ]; then
		barcode=`zbarimg -q --raw $extraparams $f  | sed ':a;N;$!ba;s/\n/_/g'`
		let end=$counter-1
		if [ $end -ne 0 ]; then #first page has barcode
			pdftk in.pdf cat $start-$end output $oldbarcode.pdf
			echo Pages $start to $end were saved into $oldbarcode.pdf in directory $$
			start=$counter
		fi
	fi
	let counter=$counter+1
	oldbarcode=$barcode 
done
let end=$counter-1
# take care of last found till end of doc
pdftk in.pdf cat $start-$end output $oldbarcode.pdf
echo Pages $start to $end were saved into $oldbarcode.pdf in directory $$

cd ..
rm -rf $$/*.png $$/in.pdf
exit 0
