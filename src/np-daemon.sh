#!/usr/bin/env bash
set -e

source "${BASH_SOURCE%/*}/shared/functions.sh"
source "${BASH_SOURCE%/*}/shared/functionality.sh"

if [[ "$1" == "--stop" ]];
then
	killPidFromFile "$configDaemonPidFile"
	killExternalPlayerIfRunning
	exit 0
fi

exitIfAlreadyRunning "$configDaemonPidFile" "daemon"
exitIfAlreadyRunning "$configPlayerPidFile" "player"

thisInstanceIsAChild="${thisInstanceIsAChild:-0}"
thisInstanceIsAChild="$(( thisInstanceIsAChild + 1 ))"

source "${BASH_SOURCE%/*}/shared/mutexed.sh"

savePidButDeleteOnExit "daemon" "$$" "$configDaemonPidFile"

startPlayer() {
	# Don't start the player unless there's a song to play.
	sound=$(getNextSound)
	[[ -z "$sound" ]] || np start 1
}

whenQueueIsChanged() {
	waitForFileChange "$configQueueFile"
}

monitorQueueFile() {
	while true;
	do
		# Use stat to get queue file last modified timestamp.
		queueUpdate=$(stat -f '%m' "$configQueueFile")

		if [[ "$prevQueueUpdate" != "$queueUpdate" ]];
		then
			debug "Queue file '${configQueueFile}' was updated: '${prevQueueUpdate}' -> '${queueUpdate}'"

			startPlayer
		else
			whenQueueIsChanged

			isDebugEnabled && echo -n "."
		fi

		prevQueueUpdate="$queueUpdate"
	done
}

prevQueueUpdate=""

monitorQueueFile