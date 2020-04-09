#!/bin/bash -eux
GRIDLABD_DIRECTORY=/home/vagrant/gridlabd
GRIDLABD_BRANCH=release/v4.2

# built following https://github.com/gridlab-d/gridlab-d/blob/release/v4.2/README-LINUX

# install dependencies
apt-get install -y autoconf automake libtool libxerces-c-dev

# clone GridLAB-D
git clone --branch $GRIDLABD_BRANCH https://github.com/gridlab-d/gridlab-d.git $GRIDLABD_DIRECTORY

# enter source directory
pushd $GRIDLABD_DIRECTORY

# configure, compile, and install
autoreconf -if
./configure --enable-silent-rules 'CFLAGS=-g -O0 -w' 'CXXFLAGS=-g -O0 -w' 'LDFLAGS=-g -O0 -w'
make
make install

# leave source directory
popd

# fix permissions
chown -R vagrant:vagrant $GRIDLABD_DIRECTORY
