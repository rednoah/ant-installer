#!/bin/sh

# Installer for Apache Ant 1.10.7
# Example: curl -O https://raw.githubusercontent.com/rednoah/ant-installer/master/release/get-ant.sh && sh -x get-ant.sh install



# fetch ant
ANT_URL="https://www.apache.org/dist/ant/binaries/apache-ant-1.10.7-bin.tar.bz2"
ANT_SHA512="d6d14cddfeed51902618cdbda338d148fd76a7e122b558ccc49af685cf1adc9f8e079e3deb3bee361cc9652fef5c859e414d6e28f15a4447751e3dd61e1df499"

# fetch tar
echo "Download $ANT_URL"
TAR=`basename $ANT_URL`
curl -v -L -o "$TAR" -z "$TAR" --retry 5 "$ANT_URL"

# verify archive via SHA512 checksum
ANT_SHA512_ACTUAL=`openssl dgst -sha512 -hex -r "$TAR" | cut -d' ' -f1`
echo "Expected SHA512 checksum: $ANT_SHA512"
echo "Actual SHA512 checksum: $ANT_SHA512_ACTUAL"

if [ "$ANT_SHA512" != "$ANT_SHA512_ACTUAL" ]; then
	echo "ERROR: SHA512 checksum mismatch"
	exit 1
fi


# unpack tar archive
echo "Extract $TAR"
tar -xvf "$TAR"


# find ant executable
export ANT_HOME="$PWD/apache-ant-1.10.7"
export ANT_EXE="$ANT_HOME/bin/ant"

# fetch optional ant libs
export ANT_OPTS="-Duser.home=$PWD"
$ANT_EXE -f "$ANT_HOME/fetch.xml" -Ddest=system


# symlink only if explicitly requested
if [ "$1" != "install" ]; then
	echo "Download complete: $TAR"
	exit 0
fi


# link ant home to /usr/local/ant
ln -sf "$ANT_HOME" "/usr/local/ant"

# link executable into /usr/local/bin/ant
mkdir -p "/usr/local/bin"
ln -sf "$ANT_EXE" "/usr/local/bin/ant"

# run ant diagnostics
echo "Execute $ANT_EXE -diagnostics"
$ANT_EXE -diagnostics
