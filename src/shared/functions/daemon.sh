#!/usr/bin/env bash
set -e

cleanupDaemon() {
	if [[ -e "$configDaemonPidFile" ]];
	then
		rm "$configDaemonPidFile"
	fi

	return 0
}

killDaemon() {
	if [[ -s "$configDaemonPidFile" ]];
	then
		killPidFromFileAndWaitUntilDead "$configDaemonPidFile"
	fi

	return 0
}

isDaemonRunning() {
	if isValidPidFileAndRunningOrCleanup "$configDaemonPidFile";
	then
		return 0
	else
		return 1
	fi
}

killDaemonIfRunning() {
	{ isDaemonRunning && killDaemon; } || true &>/dev/null

	return 0
}
