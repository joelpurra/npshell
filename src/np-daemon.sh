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
savePidButDeleteOnExit "daemon" "$$" "$configDaemonPidFile"

playSoundInPlayer() {
	local sound=$(getNextSound)
	progressQueue

	if [[ -s "$sound" ]];
	then
		echo "$sound" > "$configPlayingFile"
		highlight "$sound"
		( trap 'echo -n > "$configPlayingFile"' SIGINT EXIT; { playSound "$sound" || true; } )
	else
		errorMessage "play: sound not found: '${sound}'."
	fi

	echo -n > "$configPlayingFile"
	echo -ne '\r'
}

modePlaying() {
	# Don't start the player unless there's a song to play.
	sound=$(getNextSound)

	if [[ -z "$sound" ]];
	then
		return 1
	else
		playSoundInPlayer
	fi
}

modeStopped() {
	return 1
}

modeUnknown() {
	die "unknown mode in file '$configModeFile'."
}

getMode() {
	cat "$configModeFile"
}

checkMode() {
	local mode=$(getMode)

	debug "checkMode: '$mode'"

	case "$mode" in
		'playing')
			modePlaying
			;;
		'stopped')
			modeStopped
			;;
		'')
			modeStopped
			;;
		*)
			modeUnknown
			;;
	esac
}

whenQueueOrModeIsChanged() {
	waitForFileChange "$configQueueFile" "$configModeFile"
}

daemonLoop() {
	while true;
	do
		checkMode || whenQueueOrModeIsChanged
	done
}

daemonLoop
