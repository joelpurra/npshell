#!/usr/bin/env bash
set -e

debug() {
	[[ "$sharedDebug" == "true" ]] && { echo "DEBUG: $@" 1>&2; }
	return 0
}

errorMessage() {
	echo "play:" "$@" 1>&2
}

die() {
	errorMessage "$@"
	exit 1
	return 1
}

onExit() {
	local pidFileContents="(they are all empty)"
	(( "${#pidFilesCreatedByThisInstance[@]}" > 0 )) && { local pidFileContents=$(paste -d ' ' "${pidFilesCreatedByThisInstance[@]}"); }

	# Kill own child processes
	killPidChildren "$$"

	debug "EXIT: trapped ${pidMessagesCreatedByThisInstance[@]}"
	debug "EXIT: pid files contents: $pidFileContents"
	(( "${#pidFilesCreatedByThisInstance[@]}" > 0 )) && rm "${pidFilesCreatedByThisInstance[@]}"
	debug "EXIT: deleted ${pidFilesCreatedByThisInstance[@]}"
	return 0
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
	return 0
}

# exitIfAlreadyRunningUnlessParent() {
# 	local pidFile="$1"
# 	local pidDescriptor="$2"
# 	[[ -e "$pidFile" ]] && [[ -z "$PPID" || "$PPID" != $(cat "$pidFile") ]] && exitIfAlreadyRunning "$pidFile" "$pidDescriptor"
# 	return 0
# }

savePidButDeleteOnExit() {
	local name="$1"
	local pid="$2"
	local pidFile="$3"
	[[ -e "$pidFile" ]] && die "${pid} tried to save ${pidFile} but it already exists and contains $(cat "${pidFile}")"
	debug "creating ${name} ${pid} ${pidFile}"
	echo -n "$pid" >"$pidFile"
	debug "created ${name} ${pid} ${pidFile} ($(cat "${pidFile}"))"

	local index="${#pidFilesCreatedByThisInstance[@]}"
	pidFilesCreatedByThisInstance[index]="$pidFile"
	pidsCreatedByThisInstance[index]="$pid"
	pidMessagesCreatedByThisInstance+=("(${name} $pid $pidFile)")
	debug "${#pidFilesCreatedByThisInstance[@]} pidFilesCreatedByThisInstance: ${pidFilesCreatedByThisInstance[@]}"
	debug "${#pidsCreatedByThisInstance[@]} pidsCreatedByThisInstance: ${pidsCreatedByThisInstance[@]}"
	debug "${#pidMessagesCreatedByThisInstance[@]} pidMessagesCreatedByThisInstance: ${pidMessagesCreatedByThisInstance[@]}"

	# echo "$index"
	return 0
}

killPid() {
	local pid="$1"

	debug "about to kill '${pid}'"
	kill "${pid}"
	debug "killed '${pid}'"
}

killPidChildren() {
	# TODO: use an existing killtree kind of command to avoid orphans/zombies.
	local pid="$1"
	echo killing "${pid}"-s children
	ps -fg "${pid}" >&2
	read -a children < <(ps -fg "${pid}" | sed -e '1 d' | awk '{ print $2 " " $3 }' | sed "/^${pid}/ d" | awk '{ print $1 }')

	debug "about to kill '${pid}' children '${children[@]}'"
	for child in "${children[@]}";
	do
		killPid "${child}"
	done
	debug "killed '${pid}' children '${children[@]}'"
}

pidFromFile() {
	local pidFile="$1"

	if [[ -e "$pidFile" ]];
	then
		cat "$pidFile"
	else
		# die "could not get pid from non-existant file '$pidFile'"
		echo -n ""
	fi
}

killPidFromFile() {
	local pidFile="$1"
	local pid=$(pidFromFile "$pidFile")

	[[ -z "${pid}" ]] && die "could not get the pid to kill."

	debug "about to kill '$pid' from '$pidFile'"
	killPid "$pid"
	debug "killed '$pid' from '$pidFile'"
}

killChildrenFromFile() {
	local pidFile="$1"
	local pid=$(pidFromFile "$pidFile")

	[[ -z "${pid}" ]] && die "could not get the pid to kill child process from."

	killPidChildren "${pid}"
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