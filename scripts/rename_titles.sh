#!/bin/sh

# usage: put titles.txt and this script to your wbfs dir and run:
# ./rename_titles.sh *

# v2: fix: check if argument is a directory not a file

for F in "$@"; do
    if [ ! -d "$F" ]; then continue; fi
    FF=`basename "$F"`
    ID=`echo "$FF" | cut -s -f1 -d_`
    IDUP=`echo "$ID" | tr 'a-z' 'A-Z'`
    if [ ${#ID} = 6 -a "$ID" = "$IDUP" ]; then
        TITLE=`grep "^$ID = " titles.txt | cut -f2 -d=`
        TITLE=`echo "$TITLE" | tr '"\\/:|<>?*' '_' | tr -d '\r\n' | sed 's/ *$//;s/^ *//'`
        if [ -n "$TITLE" ]; then
            NEWF="${ID}_$TITLE"
            if [ "$FF" = "$NEWF" ]; then
                echo "$F"
            else
                NF=`dirname "$F"`/"$NEWF"
                echo "$F => $NF" 
                mv -T "$F" "$NF"
            fi
        else
            echo "$ID not found in titles.txt"
        fi
    fi
done

