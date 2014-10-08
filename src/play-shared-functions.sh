#!/usr/bin/env bash
set -e

debug() {
	echo "DEBUG: $@" 1>&2
}

errorMessage() {
	echo "play:" "$@" 1>&2
}

die() {
	errorMessage "$@"
	exit 1
	false
}

getCdw() {
	echo "$(cd -- "$PWD"; echo "$PWD")"
}

allsounds() {
	find . -name '*.mp3' -print0
}

getOrGenerateSoundCache() {
	if [[ "$sharedUseCache" == "false" ]];
	then
		allsounds
	else
		[[ -e "$sharedCacheFile" ]] || { allsounds >"$sharedCacheFile"; }

		cat "$sharedCacheFile"
	fi
}

absoluteSoundPaths() {
	# Using read seems to be about 7 times slower than sed - why?
	# while IFS= read -r -d '' sound;
	# do
	# 	echo -n "${sharedCwd}/${sound/.\/}"
	# 	echo -n -e "\0"
	# done
	nullAsNewline sed -e 's|^./||' -e "s|^|${sharedCwd}/|"
}

getSounds() {
	getOrGenerateSoundCache | absoluteSoundPaths
}

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

playSound() {
	afplay "$@"
}

highlight() {
	echo "$@" | sed "s|$sharedCwd/||" | grep --extended-regexp --color "/?[^/]+$"
}

nullAsNewline() {
	tr '\n\0' '\0\n' | "$@" | tr '\0\n' '\n\0'
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

progressQueue() {
	echo -n "$(getNextSound)" >> "$sharedHistoryFile"
	echo -n -e "\0" >> "$sharedHistoryFile"
	<"$sharedQueueFile" nullAsNewline sed '1 d' > "${sharedQueueFile}.tmp~"
	mv "${sharedQueueFile}.tmp~" "$sharedQueueFile"
}

exitIfAlreadyRunning() {
	local pidFile="$1"
	local pidDescriptor="$2"
	[[ -e "$pidFile" ]] && die "'$pidDescriptor' is already running with pid $(cat "$pidFile") according to '$pidFile'."
	true
}

# exitIfAlreadyRunningUnlessParent() {
# 	local pidFile="$1"
# 	local pidDescriptor="$2"
# 	[[ -e "$pidFile" ]] && [[ -z "$PPID" || "$PPID" != $(cat "$pidFile") ]] && exitIfAlreadyRunning "$pidFile" "$pidDescriptor"
# 	true
# }

savePidButDeleteOnExit() {
	pidFileForSavePidButDeleteOnExit="$1"
	pidForSavePidButDeleteOnExit="$2"
	trap 'debug "trapped ${pidFileForSavePidButDeleteOnExit}!"; rm -f "${pidFileForSavePidButDeleteOnExit}"; debug "deleted ${pidFileForSavePidButDeleteOnExit}!";' EXIT
	echo -n "$pidForSavePidButDeleteOnExit" >"$pidFileForSavePidButDeleteOnExit"
}

killPidFromFile() {
	local pidFile="$1"
	[[ -e "$pidFile" ]] || die "could not kill pid from non-existant file '$pidFile'"
	debug "about to kill '$(cat "$pidFile")' from '$pidFile'"
	# TODO: use a killtree kind of command to avoid orphans/zombies.
	kill "$(cat "$pidFile")"
}

ensureFoldersAndFilesExist() {
	[[ -e "$sharedConfigFolder" ]] || mkdir -p "$sharedConfigFolder"
	[[ -e "$sharedConfigFile" ]] || touch "$sharedConfigFile"
	[[ -e "$sharedQueueFile" ]] || touch "$sharedQueueFile"
	[[ -e "$sharedHistoryFile" ]] || touch "$sharedHistoryFile"
}

readConfig() {
	source "$sharedConfigFile"
}