#!/bin/bash

osrelease=$(ssh $1 cat /etc/os-release)

echo "$osrelease"|grep -q ID || exit 1
echo "$osrelease"|grep -q VERSION_ID || exit 1

eval "$osrelease"
os=${ID}${VERSION_ID}
echo $os

./getwezterm.sh $os

scp $os.tar.gz $1:wezterm.tar.gz
ssh $1 "mkdir -p .local/bin &&
    tar -C .local/bin -xzvf wezterm.tar.gz
"



