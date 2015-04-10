#!/usr/bin/env bash
set -e

externalPlayer() {
	# TODO: use dynamic index?
	local index=999
	exitIfAlreadyRunning "$configExternalPlayerPidFile" "externalplayer"
	"$externalPlayerExec" "$@" &
	local externalplayerPid="$!"
	savePidAtIndexButDeleteOnExit "$index" "externalplayer" "$externalplayerPid" "$configExternalPlayerPidFile"
	wait "$externalplayerPid" &>/dev/null
	killExternalPlayerIfRunningAndCleanup
	clearPidAtIndex "$index"
}

cleanupExternalPlayer() {
	if [[ -e "$configExternalPlayerPidFile" ]];
	then
		rm "$configExternalPlayerPidFile"
	fi

	return 0
}

killExternalPlayer() {
	if [[ -s "$configExternalPlayerPidFile" ]];
	then
		killPidFromFileAndWaitUntilDead "$configExternalPlayerPidFile"
	fi

	return 0
}

isExternalPlayerRunning() {
	if isValidPidFile "$configExternalPlayerPidFile" && isPidRunningFromFile "$configExternalPlayerPidFile";
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
	cleanupExternalPlayer
}

playSound() {
	externalPlayer "$@"
}
