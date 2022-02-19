#! /usr/bin/env bash

HOT=$XDG_RUNTIME_DIR/.cache
COLD=$HOME/.cache

if [ -f $HOT/.heated ]
then
	'Cache is already heated. Doing nothing.'
	exit 0
fi

cp 

ls -1 /root/backup_* | sort -r | tail -n +6 | xargs rm > /dev/null 2>&1
