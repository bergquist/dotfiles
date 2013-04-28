#!/bin/bash

ls -1A -- *.rar | while read FILE
do
  echo "Extracting file $FILE..."
  unrar e -kb "$FILE" /home/torrent/public
done 
