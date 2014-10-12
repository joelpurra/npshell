#!/usr/bin/env bash
set -e

cleanupExternalPlayer() {
	if [[ -e "$sharedExternalPlayerPidFile" ]];
	then
		rm "$sharedExternalPlayerPidFile"
	fi
}

killExternalPlayer() {
	if [[ -s "$sharedExternalPlayerPidFile" ]];
	then
		killPidFromFile "$sharedExternalPlayerPidFile"
	fi
}

killExternalPlayerIfRunning() {
	isValidPidFile "$sharedExternalPlayerPidFile" && isPidRunningFromFile "$sharedExternalPlayerPidFile" && killExternalPlayer
	cleanupExternalPlayer
}

playSound() {
	# TODO: use dynamic index?
	local index=999
	exitIfAlreadyRunning "$sharedExternalPlayerPidFile" "externalplayer"
	afplay "$@" &
	local externalplayerPid="$!"
	savePidAtIndexButDeleteOnExit "$index" "externalplayer" "$externalplayerPid" "$sharedExternalPlayerPidFile"
	wait "$externalplayerPid" &>/dev/null
	killExternalPlayerIfRunning
	cleanupExternalPlayer
	clearPidAtIndex "$index"
}
