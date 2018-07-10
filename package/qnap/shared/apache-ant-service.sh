#!/bin/sh
CONF="/etc/config/qpkg.conf"
QPKG_NAME="apache-ant"
QPKG_ROOT=$(/sbin/getcfg $QPKG_NAME Install_Path -f $CONF)


case "$1" in
	start)
		ENABLED=$(/sbin/getcfg $QPKG_NAME Enable -u -d FALSE -f $CONF)
		if [ "$ENABLED" != "TRUE" ]; then
			echo "$QPKG_NAME is disabled."
			exit 1
		fi

		ANT_EXE=$QPKG_ROOT/*/bin/ant
		ANT_BIN=$(dirname $JAVA_EXE)
		ANT_HOME=$(dirname $JAVA_BIN)

		/bin/ln -sf "$ANT_EXE" "/usr/bin/ant"
		/bin/ln -sf "$ANT_HOME" "/opt/ant"
		;;

	stop)
		rm -rf "/usr/bin/ant"
		rm -rf "/opt/ant"
		;;

	restart)
		$0 stop
		$0 start
		;;

	*)
		echo "Usage: $0 {start|stop|restart}"
		exit 1
esac


exit 0
