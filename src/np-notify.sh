#!/usr/bin/env bash
set -e

source "${BASH_SOURCE%/*}/shared/functions.sh"
source "${BASH_SOURCE%/*}/shared/functionality.sh"

if [[ "$1" == "--is-running" ]];
then
	if isNotificationsRunning;
	then
		exit 0
	else
		exit 1
	fi
fi

if [[ "$1" == "--stop" ]];
then
	killNotificationsIfRunning
	exit 0
fi

exitIfAlreadyRunningOrCleanup "$configNotifyPidFile" "notify"
savePidButDeleteOnExit "notify" "$$" "$configNotifyPidFile"

checkNotify() {
	local mode=$(getMode)
	local sound=$(getCurrentSound)
	local message

	notificationCount+=1

	# Don't display upon startup if np is stopped.
	if (( notificationCount == 1 )) && [[ "$mode" == "stopped" ]];
	then
		return 0
	fi

	if [[ "$mode" == "playing" && -z "$sound" ]];
	then
		# Don't display upon startup if queue is empty.
		if (( notificationCount == 1 ));
		then
			return 0
		fi

		message="Reached end of queue."
	else
		message="$sound"
	fi

	notify "$mode" "$message"
}

whenCurrentSoundIsChanged() {
	waitForFileChange "$configPlayingFile"
}

notifyLoop() {
	while true;
	do
		checkNotify
		whenCurrentSoundIsChanged
	done
}

declare -i notificationCount=0

notifyLoop
