#!/bin/sh

# @{title} for @{product} @{version}
# Example: curl -O https://raw.githubusercontent.com/rednoah/ant-installer/master/release/install-ant.sh && sh -x install-ant.sh



# fetch ant
ANT_URL="@{ant.url}"
ANT_SHA512="@{ant.sha512}"

# fetch tar
echo "Download $ANT_URL"
TAR=`basename $ANT_URL`
curl -v -L -o "$TAR" --retry 5 "$ANT_URL"

# verify archive via SHA512 checksum
ANT_SHA512_ACTUAL=`openssl dgst -sha512 -hex -r "$TAR" | cut -d' ' -f1`
echo "Expected SHA512 checksum: $ANT_SHA512"
echo "Actual SHA512 checksum: $ANT_SHA512_ACTUAL"

if [ "$ANT_SHA512" != "$ANT_SHA512_ACTUAL" ]; then
	echo "ERROR: SHA512 checksum mismatch"
	exit 1
fi

# unpack bz2-compressed tar archive
echo "Extract $TAR"
tar -vxjf "$TAR"



# find ant executable
ANT_EXE=`find "$PWD" -name "ant" -type f`

# link executable into /usr/local/bin/ant
mkdir -p "/usr/local/bin"
ln -sf "$ANT_EXE" "/usr/local/bin/ant"

# link ant home to /usr/local/ant
ANT_BIN=`dirname $ANT_EXE`
export ANT_HOME=`dirname $ANT_BIN`
ln -sf "$ANT_HOME" "/usr/local/ant"



# fetch optional ant libs
export ANT_OPTS="-Duser.home=$PWD"
export LANG="en_US.utf8"
$ANT_EXE -f "$ANT_HOME/fetch.xml" -Ddest=system



# run ant diagnostics
echo "Execute $ANT_EXE -diagnostics"
$ANT_EXE -diagnostics
