#!/usr/bin/env bash
set -e

source "${BASH_SOURCE%/*}/play-shared-functions.sh"
source "${BASH_SOURCE%/*}/play-shared-functionality.sh"

[[ "$1" == "--stop" ]] && { killPidFromFile "$sharedDaemonPidFile"; exit 0; }

exitIfAlreadyRunning "$sharedDaemonPidFile" "daemon"
exitIfAlreadyRunning "$sharedAfplayerPidFile" "afplayer"

thisInstanceIsAChild="${thisInstanceIsAChild:-0}"
thisInstanceIsAChild="$(( thisInstanceIsAChild + 1 ))"

source "${BASH_SOURCE%/*}/play-shared-functionality-mutexed.sh"

savePidButDeleteOnExit "$sharedDaemonPidFile" "$$"

ensurePlaying() {
	cat - >/dev/null
	debug "ensure playing $playerPid pid" >&2
	# kill -s SIGCONT "$playerPid"
	# debug "ensured restarted $playerPid pid" >&2
	debug "didn't really ensure restarting of $playerPid pid" >&2
}

# TODO: traverse parent chain to allow play script `play start` wrapper?
"${BASH_SOURCE%/*}/play-start.sh" --wait &
playerPid="$!"

debug "playerPid pid is $playerPid" >&2

while true;
do
	# TODO: Use something like inotify...?
	tail -F "$sharedQueueFile" | ensurePlaying
done
