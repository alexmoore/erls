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

if [ -z $ERL_HOME ]; then ERL_HOME="$HOME/.erlangs"; fi

[ -d $ERL_HOME ] || mkdir -p $ERL_HOME; 

cd $ERL_HOME
mkdir -p .src
cd .src

print_header "Installing R14B04"

[ -f otp_src_R14B04.tar.gz ] || curl -O http://www.erlang.org/download/otp_src_R14B04.tar.gz
tar xvzf otp_src_R14B04.tar.gz
cd otp_src_R14B04
CFLAGS="-O0 -DERTS_DO_INCL_GLB_INLINE_FUNC_DEF"./configure --prefix=$ERL_HOME/r14b04.64bit.no-hipe --disable-hipe --enable-smp-support --enable-threads --enable-kernel-poll  --enable-darwin-64bit
make
make install
cd ../
rm -rf otp_src_R14B04

print_header "Installing R15B01"
[ -f otp_src_R15B01.tar.gz ] || curl -O http://www.erlang.org/download/otp_src_R15B01.tar.gz
tar xvzf otp_src_R15B01.tar.gz
cd otp_src_R15B01
./configure --prefix=$ERL_HOME/r15b01.64bit.no-hipe --disable-hipe --enable-smp-support --enable-threads --enable-kernel-poll  --enable-darwin-64bit
make
make install
cd ../
rm -rf otp_src_R15B01

print_header "Installing R15B01 with +sfwi patch"
curl -O https://gist.github.com/evanmcc/a599f4c6374338ed672e/raw/524050d20a3d1fe10f1aa43b0488f26615f6d396/rg-sfwi-R15B01.patch

tar xvzf otp_src_R15B01.tar.gz
cd otp_src_R15B01
patch -p1 < ../rg-sfwi-R15B01.patch 
./configure --prefix=$ERL_HOME/r15b01.64bit.no-hipe.sfwi --disable-hipe --enable-smp-support --enable-threads --enable-kernel-poll  --enable-darwin-64bit
make
make install
cd ../
rm -rf otp_src_R15B01
 
print_header "Installing R15B03-1"
[ -f otp_src_R15B03.tar.gz ] || curl -O http://www.erlang.org/download/otp_src_R15B03-1.tar.gz
tar xvzf otp_src_R15B03-1.tar.gz
cd otp_src_R15B03
./configure --prefix=$ERL_HOME/r15b03-1.64bit.no-hipe --disable-hipe --enable-smp-support --enable-threads --enable-kernel-poll  --enable-darwin-64bit
make
make install
cd ../
rm -rf otp_src_R15B03

print_header "Installing R16B02-Basho5"
[ -f otp_src_R16B02-basho5.tar.gz ] || curl -O http://s3.amazonaws.com/downloads.basho.com/erlang/otp_src_R16B02-basho5.tar.gz
tar xzvf otp_src_R16B02-basho5.tar.gz
cd otp_src_R16B02-basho5
./configure --prefix=$ERL_HOME/r16b02.basho5.64bit.no-hipe --disable-hipe --enable-smp-support --enable-threads --enable-kernel-poll  --enable-darwin-64bit
make
make install
cd ../
rm -rf otp_src_R16B02-basho5


print_header "Setting up current link"

cd $ERL_HOME
ln -s r16b02.basho5.64bit.no-hipe current 

print_header "Setting up paths"

curl -o ~/.erl_helpers.sh https://raw2.github.com/alexmoore/erls/master/.erl_helpers.sh

echo "ERL_HOME=\"$ERL_HOME\"
export PATH=\$ERL_HOME/current/bin:\$PATH
source ~/.erl_helpers.sh" >> ~/.profile

source ~/.profile

cd $CWD
