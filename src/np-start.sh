#!/usr/bin/env bash
set -e

source "${BASH_SOURCE%/*}/shared/functions.sh"
source "${BASH_SOURCE%/*}/shared/functionality.sh"

thisInstanceIsAChild="${thisInstanceIsAChild:-0}"
thisInstanceIsAChild="$(( thisInstanceIsAChild + 1 ))"

exitIfAlreadyRunning "$configPlayerPidFile" "player"
savePidButDeleteOnExit "player" "$$" "$configPlayerPidFile"

source "${BASH_SOURCE%/*}/shared/mutexed.sh"

sound=$(getNextSound)
[[ -z "$sound" ]] && die "no sounds in queue."

playLimit="-1"

if isValidStrictlyPositiveNumber "$1";
then
	playLimit="$1"
	shift
fi

for (( i=0 ; playLimit==-1 || i<playLimit; i++));
do
	sound=$(getNextSound)
	[[ -z "$sound" ]] && break
	[[ -s "$sound" ]] || errorMessage "play: sound not found: '${sound}'."
	highlight "$sound"
	( trap 'echo -n' SIGINT; { playSound "$sound" || true; } )
	echo -ne '\r'
	progressQueue
done