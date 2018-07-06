#!/bin/bash

echo "Starting build deb"

source /etc/profile

DEBBUILDROOT=/opt/deb/

if [ -d "$DEBBUILDROOT" ]; then
    rm -rf $DEBBUILDROOT
    mkdir -p $DEBBUILDROOT
fi

PAKNAME=AutoUpdateIB
DSTPATH=${DEBBUILDROOT}${PAKNAME}

mkdir -p $DSTPATH
mkdir -p $DSTPATH/DEBIAN
mkdir -p $DSTPATH/usr/bin
mkdir -p $DSTPATH/usr/share/AutoUpdateIB/bin
mkdir -p $DSTPATH/etc/bash_completion.d

cp /opt/debian/* $DSTPATH/DEBIAN/
cp /opt/builder/AutoUpdateIB $DSTPATH/usr/bin
cp /opt/builder/AutoUpdateIB.exe $DSTPATH/usr/share/AutoUpdateIB/bin
cp /opt/builder/AutoUpdateIB-completion $DSTPATH/etc/bash_completion.d

chmod +x $DSTPATH/usr/bin/AutoUpdateIB

fakeroot dpkg-deb --build $DSTPATH

rm -rf $DSTPATH

chmod 777 $DSTPATH.deb
dpkg-name -o $DSTPATH.deb

ls -al /opt/deb

cp /opt/deb/*.deb /opt/dist/

ls -al /opt/dist
