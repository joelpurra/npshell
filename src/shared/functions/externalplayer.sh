#!/usr/bin/env bash
set -e

externalPlayer() {
	# TODO: use dynamic index?
	local index=999
	exitIfAlreadyRunningOrCleanup "$configExternalPlayerPidFile" "externalplayer"
	"$externalPlayerExec" "$@" &
	local externalplayerPid="$!"
	savePidAtIndexButDeleteOnExit "$index" "externalplayer" "$externalplayerPid" "$configExternalPlayerPidFile"
	wait "$externalplayerPid" &>/dev/null
	killExternalPlayerIfRunningAndCleanup
	clearPidAtIndex "$index"
}

killExternalPlayer() {
	if [[ -s "$configExternalPlayerPidFile" ]];
	then
		killPidFromFileAndWaitUntilDead "$configExternalPlayerPidFile"
	fi

	return 0
}

isExternalPlayerRunning() {
	if isValidPidFileAndRunningOrCleanup "$configExternalPlayerPidFile";
	then
		return 0
	else
		return 1
	fi
}

killExternalPlayerIfRunning() {
	{ isExternalPlayerRunning && killExternalPlayer; } || true &>/dev/null

	return 0
}

killExternalPlayerIfRunningAndCleanup() {
	killExternalPlayerIfRunning
	cleanupPidFile "$configExternalPlayerPidFile"

	return 0
}

playSound() {
	externalPlayer "$@"
}
