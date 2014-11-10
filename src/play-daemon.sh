#!/usr/bin/env bash
set -e

source "${BASH_SOURCE%/*}/shared/functions.sh"
source "${BASH_SOURCE%/*}/shared/functionality.sh"

if [[ "$1" == "--stop" ]];
then
	killPidFromFile "$sharedDaemonPidFile"
	killExternalPlayerIfRunning
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
	[[ -z "$sound" ]] || play start 1
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

			# This sleep is not to introduce a gap between sounds, but to wait for he queue file to be updated.
			# I think. Should be checked. Suspect there's a problem with the async `wait`ing for the external player's
			# process to die, which makes parts of the code react faster than others leading to race conditions.
			# Sleep generally doesn't accept float values accoring to the man page, but on this system it does.
			sleep 0.1
		else
			# Use a longer sleep, then send signal SIGVTALRM (26) or SIGALRM (14) on `play add`?
			sleep 1

			isDebugEnabled && echo -n "."
		fi

		prevQueueUpdate="$queueUpdate"
	done
}

prevQueueUpdate=""

monitorQueueFile