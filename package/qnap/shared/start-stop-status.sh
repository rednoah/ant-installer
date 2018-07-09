#!/bin/sh
CONF="/etc/config/qpkg.conf"
QPKG_NAME="apache-ant"
QPKG_ROOT=`/sbin/getcfg $QPKG_NAME Install_Path -f $CONF`


QPKG_LOG="$QPKG_ROOT/install-ant.log"
SYS_PROFILE="/etc/profile"
COMMENT="# added by Ant Installer"


case "$1" in
	start)
		ENABLED=$(/sbin/getcfg $QPKG_NAME Enable -u -d FALSE -f $CONF)
		if [ "$ENABLED" != "TRUE" ]; then
			echo "$QPKG_NAME is disabled."
			exit 1
		fi

		# find ant executable
		ANT_EXE=`find "$QPKG_ROOT" -name "ant" -type f`
		ANT_BIN=`dirname $ANT_EXE`
		ANT_HOME=`dirname $ANT_BIN`

		ln -sf "$ANT_EXE" "/usr/bin/ant"
		ln -sf "$ANT_HOME" "/usr/share/ant"

		# make sure that `ant` is working
		if [ -x "/usr/share/ant/bin/ant" ]; then
			# display success message
			export ANT_HOME="/usr/share/ant" && "/usr/share/ant/bin/ant" -version >> "$QPKG_LOG" 2>&1
		else
			# display error message
			err_log "Ooops, something went wrong... View Log for details... $QPKG_LOG"
		fi

		# add ANT_HOME to system-wide profile
		if [ `grep -c "$COMMENT" $SYS_PROFILE` == "0" ]; then
			if [ -x "/usr/share/ant/bin/ant" ]; then
				echo "Add environment variables to $SYS_PROFILE" >> "$QPKG_LOG"

				# add environment variables to /etc/profile
				echo "export ANT_HOME=/usr/share/ant      $COMMENT" >> "$SYS_PROFILE"
			fi
		fi
	;;

	stop)
		# remove symlinks
		rm "/usr/bin/ant"
		rm "/usr/share/ant"

		# remove /etc/profile additions
		sed -i "/${COMMENT}/d" "$SYS_PROFILE"
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
