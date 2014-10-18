#!/usr/bin/env bash
set -e

shuffle() {
	gshuf -z
}

playOrder() {
	if [[ "$sharedOrder" == "random" ]]; then
		shuffle
	elif [[ "$sharedOrder" == "in-order" ]]; then
		cat -
	else
		die "Unknown order: $sharedOrder"
	fi
}

limit() {
	if (( sharedNumsounds > 0 )); then
		nullAsNewline head -n "$sharedNumsounds"
	else
		cat -
	fi
}

getNextSound() {
	{ IFS= read -r -d '' sound || true; } < <(head -c 2048 "$sharedQueueFile")
	echo "$sound"
}

pushSoundToHistory() {
	local sound=$(getNextSound)

	[[ -z "$sound" ]] && return 0

	echo -n "$sound" >> "$sharedHistoryFile"
	echo -n -e "\0" >> "$sharedHistoryFile"
}

progressQueue() {
	pushSoundToHistory
	<"$sharedQueueFile" nullAsNewline sed '1 d' > "${sharedQueueFile}.tmp~"
	mv "${sharedQueueFile}.tmp~" "$sharedQueueFile"
}
