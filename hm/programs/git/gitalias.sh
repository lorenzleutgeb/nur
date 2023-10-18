#! /usr/bin/env bash

if [ $# == 1 ]
then
	REV="$1"
else
	REV=main
fi

URL="https://github.com/GitAlias/gitalias/raw/${REV}/gitalias.txt"

cat << EOM
# This file was automatically generated from
#
#   $URL
#
# on $(date --iso-8601=sec)
#
# DO NOT EDIT MANUALLY!
EOM

echo "{"

curl -L "$URL" |
GIT_CONFIG=/dev/stdin git config --null --get-regexp "^alias." |
{
while read -r -d $'\n' key
do
	key=${key:6}
	read -r -d $'\0' value
	echo "\"$key\" = \"$(sed -f gitalias.sed <<< "$value")\";"
done
}

echo "}"
