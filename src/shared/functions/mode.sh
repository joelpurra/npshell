#!/usr/bin/env bash
set -e

# This function is a mixture of displaying and process control. Is there a better place for it?
playSoundInPlayer() {
	local sound=$(getNextSound)
	progressQueue

	if [[ -s "$sound" ]];
	then
		echo "$sound" > "$configPlayingFile"

		if [[ "$verboseOutput" == "true" ]];
		then
			highlight "$(getCurrentSound)"
			echo -ne '\r'
		fi

		( trap 'echo -n > "$configPlayingFile"' SIGINT EXIT; { playSound "$sound" || true; } )
	else
		errorMessage "play: sound not found: '${sound}'."
	fi

	echo -n > "$configPlayingFile"
}

setModeStart() {
	echo "playing" > "$configModeFile"
}

setModeStop() {
	echo "stopped" > "$configModeFile"

	killExternalPlayerIfRunning
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
