#!/usr/bin/env bash
set -e

source "${BASH_SOURCE%/*}/shared/functions.sh"
source "${BASH_SOURCE%/*}/shared/functionality.sh"

# TODO: fix stopping the daemon.
if [[ "$1" == "--stop" ]];
then
	# killChildrenFromFile "$sharedDaemonPidFile"
	killPidFromFile "$sharedDaemonPidFile"
	# killPlayerIfRunning maybe?
	# killExternalPlayerIfRunning maybe?
	exit 0
fi

exitIfAlreadyRunning "$sharedDaemonPidFile" "daemon"
exitIfAlreadyRunning "$sharedPlayerPidFile" "player"

thisInstanceIsAChild="${thisInstanceIsAChild:-0}"
thisInstanceIsAChild="$(( thisInstanceIsAChild + 1 ))"

source "${BASH_SOURCE%/*}/shared/mutexed.sh"

savePidButDeleteOnExit "daemon" "$$" "$sharedDaemonPidFile"

startPlayer() {
	# Don't start the player unless there's a song to play.
	sound=$(getNextSound)
	[[ -z "$sound" ]] || play start
}

monitorQueueFile() {
	while true;
	do
		# TODO: Use something like inotify...?
		# tail -F "$sharedQueueFile" | ensurePlaying
		# Use stat to get queue file last modified timestamp.
		queueUpdate=$(stat -f '%m' "$sharedQueueFile")
		if [[ "$prevQueueUpdate" != "$queueUpdate" ]];
		then
			debug "$prevQueueUpdate -> $queueUpdate"
			startPlayer
		else
			isDebugEnabled && echo -n "."
		fi

		prevQueueUpdate="$queueUpdate"

		sleep 1
	done
}

prevQueueUpdate=""

monitorQueueFile