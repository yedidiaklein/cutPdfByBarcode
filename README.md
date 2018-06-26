# cutPdfByBarcode
A shell script that uses Linux utilities to cut PDF that contains barcode in front of each part

Use example.pdf file as input, and it will generate 4 pdfs, each of them start with the page with the barcode, and also filenames are the content of barcode.

It supports these kinds of barcodes :
EAN/UPC (EAN-13, EAN-8, UPC-A, UPC-E, ISBN-10, ISBN-13),
Code 128, Code 39 and Interleaved 2 of 5

You should install the following utilities:
pdftoppm, zbarimg and pdftk

on Debian/Ububntu/Mint you could install them using the following command:
sudo apt install pdftk zbar-tools poppler-utils

Usage:
./cut.sh example.pdf
