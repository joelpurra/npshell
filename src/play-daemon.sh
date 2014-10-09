#!/usr/bin/env bash
set -e

source "${BASH_SOURCE%/*}/play-shared-functions.sh"
source "${BASH_SOURCE%/*}/play-shared-functionality.sh"

if [[ "$1" == "--stop" ]];
then
	# killChildrenFromFile "$sharedDaemonPidFile"
	killPidFromFile "$sharedDaemonPidFile"
	exit 0
fi

exitIfAlreadyRunning "$sharedDaemonPidFile" "daemon"
exitIfAlreadyRunning "$sharedAfplayerPidFile" "afplayer"

thisInstanceIsAChild="${thisInstanceIsAChild:-0}"
thisInstanceIsAChild="$(( thisInstanceIsAChild + 1 ))"

source "${BASH_SOURCE%/*}/play-shared-functionality-mutexed.sh"

savePidButDeleteOnExit "daemon" "$$" "$sharedDaemonPidFile"

startPlayer() {
	# Don't start the player unless there's a song to play.
	# TODO: traverse parent chain to allow play script `play start` wrapper?
	sound=$(getNextSound)
	[[ -z "$sound" ]] || "${BASH_SOURCE%/*}/play-start.sh" --wait
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