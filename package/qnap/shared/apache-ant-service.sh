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

		ANT_EXE=$(find $QPKG_ROOT -name ant -type f | head -n 1)
		ANT_BIN=$(dirname $ANT_EXE)
		ANT_HOME=$(dirname $ANT_BIN)

		/bin/ln -sf "$ANT_EXE" "/usr/bin/ant"
		/bin/ln -sf "$ANT_HOME" "/opt/ant"

		if [ -x "/usr/bin/ant" ]; then
			# display success message
			/sbin/log_tool -t0 -uSystem -p127.0.0.1 -mlocalhost "$(/usr/bin/ant -version 2>&1)"
		else
			# display error message
			/sbin/log_tool -t2 -uSystem -p127.0.0.1 -mlocalhost "Ooops, something went wrong... Run \`$QPKG_ROOT/install-ant.log\` for details."
		fi
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
