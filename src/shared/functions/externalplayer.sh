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
	killExternalPlayerIfRunning
	clearPidAtIndex "$index"
}

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

isExternalPlayerRunning() {
	if isValidPidFile "$configExternalPlayerPidFile" && isPidRunningFromFile "$configExternalPlayerPidFile";
	then
		return 0
	else
		return 1
	fi
}

killExternalPlayerIfRunning() {
	{ isExternalPlayerRunning && killExternalPlayer; } &>/dev/null
	cleanupExternalPlayer
}

playSound() {
	externalPlayer "$@"
}
