#!/bin/bash

osrelease=$(ssh $1 cat /etc/os-release)

echo "$osrelease"|grep -q ID || exit 1
echo "$osrelease"|grep -q VERSION_ID || exit 1

eval "$osrelease"
os=${ID}${VERSION_ID}
echo $os

./getwezterm.sh $os

echo ssh $1 mkdir
ssh $1 "mkdir -p .local/bin"

echo ssh "cat $os.tar.gz |ssh $1 tar -C .local/bin -xzv"
cat $os.tar.gz |ssh $1 "tar -C .local/bin -xzv"
ssh $1 "pkill -e wezterm"
