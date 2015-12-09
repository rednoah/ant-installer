#!/bin/sh

# @{title} for @{product} @{version}
# Example: curl -O https://raw.githubusercontent.com/rednoah/ant-installer/master/release/install-ant.sh && sh -x install-ant.sh

ANT_URL="@{ant.url}"
ANT_MD5="@{ant.md5}"
IVY_URL="@{ivy.url}"
IVY_MD5="@{ivy.md5}"

# fetch ant and ivy binaries
fetch()
{
	URL="$1"
	MD5="$2"

	# fetch tar
	echo "Download $URL"
	TAR=`basename $URL`
	curl -v -L -o "$TAR" --retry 5 "$URL"

	# verify archive via MD5 checksum
	MD5_ACTUAL=`openssl dgst -md5 -hex -r "$TAR" | cut -d' ' -f1`
	echo "Expected MD5 checksum: $MD5"
	echo "Actual MD5 checksum: $MD5_ACTUAL"

	if [ "$MD5" != "$MD5_ACTUAL" ]; then
		echo "ERROR: MD5 checksum mismatch"
		exit 1
	fi

	echo "Extract $TAR"
	tar -vzxf "$TAR"
}

fetch "$ANT_URL" "$ANT_MD5"
fetch "$IVY_URL" "$IVY_MD5"

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
$ANT_EXE -f "$ANT_HOME/fetch.xml" -Ddest=system

# link ivy into the ant lib folder
IVY_JAR=`find "$PWD" -name "ivy-*.*.*.jar" -type f`
IVY_ANT_LIB="$ANT_HOME/lib/`basename $IVY_JAR`"
echo "Link $IVY_ANT_LIB to $IVY_JAR"
ln -sf "$IVY_JAR" "$IVY_ANT_LIB"

# run ant diagnostics
echo "Execute $ANT_EXE -diagnostics"
$ANT_EXE -diagnostics
