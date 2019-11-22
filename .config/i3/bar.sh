#!/bin/bash

i3status | while :
do
    read line
    LG=$(setxkbmap -query | awk '/layout/{print $2}')
    if [ $LG == "de" ]
    then
        dat="[{ \"full_text\": \"$LG\", \"color\":\"#009E00\" },"
    else
        dat="[{ \"full_text\": \"$LG\", \"color\":\"#C60101\" },"
    fi
    echo "${line/[/$dat}" || exit 1
done
