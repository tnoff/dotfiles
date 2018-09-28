#!/bin/bash

## Usage
## ./split-pdf <pdf-file> [<name-file>]
## pdf-file -- PDF File you want to split into many files
## name-file -- Optional: names of new individual files


# Only required arg
PDF_FILE=$1
if [ -z ${PDF_FILE} ] ; then
    echo "Must enter pdf file"
    exit 1
fi

# Number of Pages in PDF File
NUM_PAGES=$(pdftk $PDF_FILE dump_data  2>/dev/null | sed -nr 's/^NumberOfPages\:\ ([0-9]+).*/\1/p')
echo "Number Pages: ${NUM_PAGES}"

# If num pages less than 2, no point in splitting file
if [ ${NUM_PAGES} -lt 2 ]; then
    echo "Number of pages then than 2, exiting"
    exit 1
fi

# Check for optional arg
NAME_FILE=$2


# For number of pages, get each individual page
COUNT=1
while [ ${COUNT} -le ${NUM_PAGES} ] ; do
    echo "${COUNT}"
    # If name file not given, just use file name
    if [ -z "${NAME_FILE}" ] ; then
        pdftk "${PDF_FILE}" cat "${COUNT}" output "${COUNT}-${PDF_FILE}"
    # Else grab name from file
    else
        NAME=$(sed "${COUNT}q;d" $NAME_FILE)
        pdftk "${PDF_FILE}" cat "${COUNT}" output "${NAME}.pdf"
    fi
    ((COUNT++))
done
