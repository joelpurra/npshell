#!/usr/bin/env bash
set -e

shuffle() {
	# Kind of assuming GNU `shuf`; haven't tested the -z flag on anything else.
	"$externalShuffleExec" -z
}

playOrder() {
	if [[ "$configOrder" == "shuffle" ]]; then
		shuffle
	elif [[ "$configOrder" == "in-order" ]]; then
		cat -
	else
		die "Unknown order: ${configOrder}"
	fi
}

limit() {
	if (( configNumsounds > 0 )); then
		nullAsNewline head -n "$configNumsounds"
	else
		cat -
	fi
}

getNextSound() {
	{ IFS= read -r -d '' sound || true; } < <(head -c 2048 "$configQueueFile")
	echo -nE "$sound"
}

getCurrentSound() {
	cat "$configPlayingFile"
}

pushSoundToHistory() {
	local sound=$(getNextSound)

	[[ -z "$sound" ]] && return 0

	echo -nE "$sound" >> "$configHistoryFile"
	echo -ne "\0" >> "$configHistoryFile"
}

progressQueue() {
	pushSoundToHistory
	<"$configQueueFile" nullAsNewline sed '1 d' > "${configQueueFile}.tmp~"
	mv "${configQueueFile}.tmp~" "$configQueueFile"
}
