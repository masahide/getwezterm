#!/bin/bash

apiurl=https://api.github.com/repos/wez/wezterm/releases/latest

deb () {
    os=$1
    docker run -e u=$(id -u) -e g=$(id -g) -v $PWD:/mnt \
     -it --rm ubuntu:22.04 bash -c \
     'apt update -y &&
     apt install -y jq curl && 
     curl -sL $(curl -sL '$apiurl'|jq -r ".assets[].browser_download_url"|grep -i '$os'|grep deb$) -o wezterm.deb && 
     dpkg-deb -x wezterm.deb wezterm && 
     tar -C wezterm/usr/bin -czvf /mnt/'$os'.tar.gz wezterm wezterm-mux-server &&
     chown $u:$g /mnt/'$os'.tar.gz'
}

rpm () {
    os=$1
    docker run -e u=$(id -u) -e g=$(id -g) -v $PWD:/mnt \
     -it --rm ubuntu:22.04 bash -c \
    'apt update -y && apt install -y rpm2cpio jq cpio curl &&
    curl -sL $(curl -sL '$apiurl'|jq -r ".assets[].browser_download_url"|grep -i '$os'|grep rpm$) | rpm2cpio | cpio -idv &&
    tar -C usr/bin -czf /mnt/'$os'.tar.gz wezterm wezterm-mux-server &&
    chown $u:$g /mnt/'$os'.tar.gz'
}


case $1 in
    ubuntu18 | ubuntu20 | ubuntu22 | debian10 | debian11)
        [[ -e $1.tar.gz ]] || deb $1;;
    centos7 | centos8 | centos9)
        [[ -e $1.tar.gz ]] || rpm $1;;
    *)
        echo undefined OS;;
esac


