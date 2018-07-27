#!/bin/sh
CONF="/etc/config/qpkg.conf"
QPKG_NAME="@{package}"
QPKG_ROOT=$(/sbin/getcfg $QPKG_NAME Install_Path -f $CONF)


case "$1" in
	start)
		ENABLED=$(/sbin/getcfg $QPKG_NAME Enable -u -d FALSE -f $CONF)
		if [ "$ENABLED" != "TRUE" ]; then
			echo "$QPKG_NAME is disabled."
			exit 1
		fi

		ANT_EXE=$(find $QPKG_ROOT -name ant -type f | head -n 1)
		ANT_BIN=$(dirname $ANT_EXE)
		ANT_HOME=$(dirname $ANT_BIN)

		ln -sf "$ANT_EXE" "/usr/bin/ant"
		ln -sf "$ANT_HOME" "/opt/ant"
		exit 0
	;;

	stop)
		rm -rf "/usr/bin/ant"
		rm -rf "/opt/ant"
		exit 0
	;;

	restart)
		$0 stop
		$0 start
		exit 0
	;;

	*)
		echo "Usage: $0 {start|stop|restart}"
		exit 1
esac
