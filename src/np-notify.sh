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


getNotificationTitleFromSound() {
	local sound="$1"

	# Fallback value.
	local detail="np"

	local title="$(getSoundDetailArtist "$sound")"

	if [[ ! -z "$title" ]];
	then
		detail="$title"
	fi

	echo -E "$detail"
}

getNotificationSubtitleFromSound() {
	local sound="$1"

	# Fallback value.
	local detail="playing"

	local album="$(getSoundDetailAlbum "$sound")"

	if [[ ! -z "$album" ]];
	then
		detail="$album"
	fi

	echo -E "$detail"
}

getNotificationMessageFromSound() {
	local sound="$1"

	# Fallback value.
	local detail="$sound"

	local title="$(getSoundDetailTitle "$sound")"

	if [[ ! -z "$title" ]];
	then
		detail="$title"
	fi

	echo -E "$detail"
}


checkNotify() {
	local mode=$(getMode)
	local sound=$(getCurrentSound)
	local title
	local subtitle
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

		title="np"
		subtitle="Reached end of queue."
		# TODO: encourage user to click on the notification bubble, and add more songs from the default directory if they do?
		message=""
	else
		title="$(getNotificationTitleFromSound "$sound")"
		subtitle="$(getNotificationSubtitleFromSound "$sound")"
		message="$(getNotificationMessageFromSound "$sound")"
	fi

	notify "$title" "$subtitle" "$message"
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
