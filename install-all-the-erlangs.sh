#!/bin/bash

CWD=$(pwd)

print_hr() {
    printf '%80s\n' | tr ' ' -
}

print_header() {
    print_hr;
    echo $1; 
    print_hr;
}

print_header "Creating ERL Home"

if [ -z $ERL_HOME ]; then ERL_HOME="$HOME/erlangs"; fi

[ -d $ERL_HOME ] || mkdir -p $ERL_HOME; 

cd /tmp/

print_header "Installing R14B04"

curl -O http://www.erlang.org/download/otp_src_R14B04.tar.gz
tar xvzf otp_src_R14B04.tar.gz
cd otp_src_R14B04
CFLAGS=-O0 ./configure --prefix=$ERL_HOME/R14B04.64bit.no-hipe --disable-hipe --enable-smp-support --enable-threads --enable-kernel-poll  --enable-darwin-64bit
make
make install
cd ../

print_header "Installing R15B01"
curl -O http://www.erlang.org/download/otp_src_R15B01.tar.gz
tar xvzf otp_src_R15B01.tar.gz
cd otp_src_R15B01
./configure --prefix=$ERL_HOME/R15B01.64bit.no-hipe --disable-hipe --enable-smp-support --enable-threads --enable-kernel-poll  --enable-darwin-64bit
make
make install
cd ../

print_header "Installing R15B01 with +sfwi patch"
rm -rf otp_src_R15B01
curl -O https://gist.github.com/evanmcc/a599f4c6374338ed672e/raw/524050d20a3d1fe10f1aa43b0488f26615f6d396/rg-sfwi-R15B01.patch

tar xvzf otp_src_R15B01.tar.gz
cd otp_src_R15B01
patch -p1 < ../rg-sfwi-R15B01.patch 
./configure --prefix=$ERL_HOME/R15B01.64bit.no-hipe.sfwi --disable-hipe --enable-smp-support --enable-threads --enable-kernel-poll  --enable-darwin-64bit
make
make install
cd ../
 
print_header "Installing R15B03-1"
curl -O http://www.erlang.org/download/otp_src_R15B03-1.tar.gz
tar xvzf otp_src_R15B03-1.tar.gz
cd otp_src_R15B03
./configure --prefix=$ERL_HOME/R15B03-1.64bit.no-hipe --disable-hipe --enable-smp-support --enable-threads --enable-kernel-poll  --enable-darwin-64bit
make
make install
cd ../

print_header "Installing R16B02"
curl -O http://www.erlang.org/download/otp_src_R16B02.tar.gz
tar xzvf otp_src_R16B02.tar.gz
cd otp_src_R16B02
./configure --prefix=$ERL_HOME/R16B02.64bit.no-hipe --disable-hipe --enable-smp-support --enable-threads --enable-kernel-poll  --enable-darwin-64bit
make
make install
cd ../


print_header "Cleaning up"
rm otp_src_R14B04.tar.gz
rm otp_src_R15B01.tar.gz
rm otp_src_R15B03-1.tar.gz
rm otp_src_R16B02.tar.gz

rm -rf otp_src_R14B04
rm -rf otp_src_R15B01
rm -rf otp_src_R15B03
rm -rf otp_src_R16B02

print_header "Setting up current link"

cd $ERL_HOME
ln -s R15B01.64bit.no-hipe.sfwi current 

print_header "Setting up paths"

curl -o ~/.erl_helpers.sh https://gist.github.com/alexmoore/6276902/raw/a1fb2131485ddbafd3d641e6ff55db6a4668810d/erl_helpers.sh

echo "ERL_HOME=\"$ERL_HOME\"
export PATH=\$ERL_HOME/current/bin:\$PATH
source ~/.erl_helpers.sh" >> ~/.profile

source ~/.profile

cd $CWD
