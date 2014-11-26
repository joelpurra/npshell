#!/usr/bin/env bash
set -e

cleanupExternalPlayer() {
	if [[ -e "$configExternalPlayerPidFile" ]];
	then
		rm "$configExternalPlayerPidFile"
	fi
}

killExternalPlayer() {
	if [[ -s "$configExternalPlayerPidFile" ]];
	then
		killPidFromFile "$configExternalPlayerPidFile"
	fi
}

killExternalPlayerIfRunning() {
	{ isValidPidFile "$configExternalPlayerPidFile" && isPidRunningFromFile "$configExternalPlayerPidFile" && killExternalPlayer; } &>/dev/null
	cleanupExternalPlayer
}

playSound() {
	# TODO: use dynamic index?
	local index=999
	exitIfAlreadyRunning "$configExternalPlayerPidFile" "externalplayer"
	afplay "$@" &
	local externalplayerPid="$!"
	savePidAtIndexButDeleteOnExit "$index" "externalplayer" "$externalplayerPid" "$configExternalPlayerPidFile"
	wait "$externalplayerPid" &>/dev/null
	killExternalPlayerIfRunning
	clearPidAtIndex "$index"
}
