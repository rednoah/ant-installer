#!/bin/sh

# Installer for Apache Ant 1.10.4
# Example: curl -O https://raw.githubusercontent.com/rednoah/ant-installer/master/release/get-ant.sh && sh -x get-ant.sh install



# fetch ant
ANT_URL="https://www.apache.org/dist/ant/binaries/apache-ant-1.10.4-bin.tar.xz"
ANT_SHA512="5f61734a7bfec775a272dd827ee84364d5328742dbcc72f9acbfeb2bb44a13b34c7673d75be41748510ca31c053ccbf9160874055213fff893f5df2043ba8b03"

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
export ANT_EXE=`find "$PWD" -name "ant" -type f`
export ANT_BIN=`dirname $ANT_EXE`
export ANT_HOME=`dirname $ANT_BIN`

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
