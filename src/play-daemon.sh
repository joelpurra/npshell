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

# startPlayer() {
# 	# TODO: traverse parent chain to allow play script `play start` wrapper?
# 	"${BASH_SOURCE%/*}/play-start.sh" --wait &
# 	playerPid="$!"

# 	debug "playerPid pid is $playerPid"
# }

# ensureStarted() {
# 	while [[ -z "${playerPid}" ]];
# 	do
# 		playerPid=$(pidFromFile "$sharedAfplayerPidFile")

# 		startPlayer
# 		sleep 1
# 	done
# }

# ensurePlaying() {
# 	# Discard input
# 	# cat - >/dev/null

# 	ensureStarted

# 	debug "ensure playing $playerPid pid"
# 	kill -s SIGCONT "$playerPid"
# 	debug "ensured restarted $playerPid pid"
# 	# debug "didn't really ensure restarting of $playerPid pid"
# }

# prevQueueChecksum=""

# monitorQueueFile() {
# 	while true;
# 	do
# 		# TODO: Use something like inotify...?
# 		# tail -F "$sharedQueueFile" | ensurePlaying
# 		queueChecksum=$(shasum -a 256 "$sharedQueueFile")
# 		if [[ "$prevQueueChecksum" != "$queueChecksum" ]];
# 		then
# 			debug "$prevQueueChecksum -> $queueChecksum"
# 			ensurePlaying
# 		fi

# 		prevQueueChecksum="$queueChecksum"

# 		sleep 1
# 	done
# }

# monitorQueueFile

# Don't do anything fancy
"${BASH_SOURCE%/*}/play-start.sh" --wait