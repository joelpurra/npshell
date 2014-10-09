#!/usr/bin/env bash
set -e

[[ "$1" == "--wait" ]] && { shift; shouldWait="true"; thisInstanceIsAChild="${thisInstanceIsAChild:-0}"; thisInstanceIsAChild="$(( thisInstanceIsAChild + 1 ))"; }

source "${BASH_SOURCE%/*}/play-shared-functions.sh"
source "${BASH_SOURCE%/*}/play-shared-functionality.sh"
source "${BASH_SOURCE%/*}/play-shared-functionality-mutexed.sh"

exitIfAlreadyRunning "$sharedAfplayerPidFile" "afplayer"
savePidButDeleteOnExit "afplayer" "$$" "$sharedAfplayerPidFile"

sound=$(getNextSound)
[[ "$shouldWait" != "true" && -z "$sound" ]] && die "no sounds in queue."

# Enable job control.
set -m

while true;
do
	while true;
	do
		sound=$(getNextSound)
		[[ -z "$sound" ]] && { break; }
		[[ -s "$sound" ]] || { errorMessage "play: sound not found: '$sound'."; break; }
		highlight "$sound"
		if [[ "$shouldWait" != "true" ]];
		then
			( trap 'echo -n' SIGINT; { playSound "$sound" || true; } )
		else
			playSound "$sound"
		fi
		echo -ne '\r'
		progressQueue
	done

	if [[ "$shouldWait" == "true" ]];
	then
		# debug "shouldWait: $shouldWait"
		# sleep 1

		( trap 'exit 1' SIGINT; { sleep 1 || true; } )

		# suspend || die "could not suspend process $$"
	else
		exit 0
	fi
done

set +m
