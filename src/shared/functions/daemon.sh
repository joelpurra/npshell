#!/usr/bin/env bash
set -e

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
