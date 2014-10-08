#!/usr/bin/env bash
set -e

[[ "$1" == "--wait" ]] && { shift; shouldWait="true"; thisInstanceIsAChild="${thisInstanceIsAChild:-0}"; thisInstanceIsAChild="$(( thisInstanceIsAChild + 1 ))"; }

source "${BASH_SOURCE%/*}/play-shared-functions.sh"
source "${BASH_SOURCE%/*}/play-shared-functionality.sh"

exitIfAlreadyRunning "$sharedAfplayerPidFile" "afplayer"

source "${BASH_SOURCE%/*}/play-shared-functionality-mutexed.sh"

sound=$(getNextSound)
[[ "$shouldWait" != "true" && -z "$sound" ]] && die "no sounds in queue."

while true;
do
	while true;
	do
		sound=$(getNextSound)
		[[ -z "$sound" ]] && { break; }
		[[ -s "$sound" ]] || { errorMessage "play: sound not found: '$sound'."; break; }
		highlight "$sound"
		( exitIfAlreadyRunning "$sharedAfplayerPidFile" "afplayer" && trap 'echo -n' SIGINT; { playSound "$sound" || true; }; savePidButDeleteOnExit "$sharedAfplayerPidFile" "$afplayerPid" )
		echo -ne '\r'
		progressQueue
	done

	if [[ "$shouldWait" == "true" ]];
	then
		debug "shouldWait: $shouldWait"
		sleep 1
		# suspend -f || die "could not suspend process $$"
	else
		exit 0
	fi
done
