#!/usr/bin/env bash
set -e

source "${BASH_SOURCE%/*}/play-shared-functions.sh"
source "${BASH_SOURCE%/*}/play-shared-functionality.sh"

if [[ "$1" == "--wait" ]];
then
	shift
	thisInstanceIsAChild="${thisInstanceIsAChild:-0}"
	thisInstanceIsAChild="$(( thisInstanceIsAChild + 1 ))"
fi

exitIfAlreadyRunning "$sharedPlayerPidFile" "player"
savePidButDeleteOnExit "player" "$$" "$sharedPlayerPidFile"

source "${BASH_SOURCE%/*}/play-shared-functionality-mutexed.sh"

sound=$(getNextSound)
[[ -z "$sound" ]] && die "no sounds in queue."

while true;
do
	sound=$(getNextSound)
	[[ -z "$sound" ]] && break
	[[ -s "$sound" ]] || errorMessage "play: sound not found: '$sound'."
	highlight "$sound"
	( trap 'echo -n' SIGINT; { playSound "$sound" || true; } )
	echo -ne '\r'
	progressQueue
done