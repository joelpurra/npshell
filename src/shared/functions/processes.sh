#!/usr/bin/env bash
set -e

onExit() {
	local pidFileContents="(they are all empty)"
	(( "${#pidFilesCreatedByThisInstance[@]}" > 0 )) && { local pidFileContents=$(paste -d ' ' "${pidFilesCreatedByThisInstance[@]}"); }

	# Kill own child processes
	#killPidChildren "$$"

	debug "EXIT: trapped ${pidMessagesCreatedByThisInstance[@]}"
	debug "EXIT: pid files contents: ${pidFileContents}"
	(( "${#pidFilesCreatedByThisInstance[@]}" > 0 )) && rm "${pidFilesCreatedByThisInstance[@]}"
	debug "EXIT: deleted ${pidFilesCreatedByThisInstance[@]}"

	exit 0
}

exitIfAlreadyRunning() {
	local pidFile="$1"
	local pidDescriptor="$2"
	[[ -e "$pidFile" ]] && die "'${pidDescriptor}' is already running with pid $(cat "$pidFile") according to '${pidFile}'."
	return 0
}

# exitIfAlreadyRunningUnlessParent() {
# 	local pidFile="$1"
# 	local pidDescriptor="$2"
# 	[[ -e "$pidFile" ]] && [[ -z "$PPID" || "$PPID" != $(cat "$pidFile") ]] && exitIfAlreadyRunning "$pidFile" "$pidDescriptor"
# 	return 0
# }

savePidAtIndexButDeleteOnExit() {
	local index="$1"
	local name="$2"
	local pid="$3"
	local pidFile="$4"
	[[ -e "$pidFile" ]] && die "${pid} tried to save ${pidFile} but it already exists and contains $(cat "${pidFile}")"
	debug "creating ${name} ${pid} ${pidFile}"
	echo -nE "$pid" >"$pidFile"
	debug "created ${name} ${pid} ${pidFile} ($(cat "${pidFile}"))"

	pidFilesCreatedByThisInstance[index]="$pidFile"
	pidsCreatedByThisInstance[index]="$pid"
	pidMessagesCreatedByThisInstance[index]="(${name} ${pid} ${pidFile})"
	debug "${#pidFilesCreatedByThisInstance[@]} pidFilesCreatedByThisInstance: ${pidFilesCreatedByThisInstance[@]}"
	debug "${#pidsCreatedByThisInstance[@]} pidsCreatedByThisInstance: ${pidsCreatedByThisInstance[@]}"
	debug "${#pidMessagesCreatedByThisInstance[@]} pidMessagesCreatedByThisInstance: ${pidMessagesCreatedByThisInstance[@]}"

	return 0
}

clearPidAtIndex() {
	local index="$1"

	unset pidFilesCreatedByThisInstance[index]
	unset pidsCreatedByThisInstance[index]
	unset pidMessagesCreatedByThisInstance[index]
	debug "${#pidFilesCreatedByThisInstance[@]} pidFilesCreatedByThisInstance: ${pidFilesCreatedByThisInstance[@]}"
	debug "${#pidsCreatedByThisInstance[@]} pidsCreatedByThisInstance: ${pidsCreatedByThisInstance[@]}"
	debug "${#pidMessagesCreatedByThisInstance[@]} pidMessagesCreatedByThisInstance: ${pidMessagesCreatedByThisInstance[@]}"

	return 0
}

savePidButDeleteOnExit() {
	local index="${#pidFilesCreatedByThisInstance[@]}"
	savePidAtIndexButDeleteOnExit "$index" "$1" "$2" "$3"
}

killPid() {
	local pid="$1"

	debug "about to kill '${pid}'"
	kill "${pid}"
	debug "killed '${pid}'"
}

killPidAndWaitUntilDead() {
	local pid="$1"

	killPid "${pid}"
	debug "waiting for '${pid}' to die"
	wait "$pid" &>/dev/null
}

killPidChildren() {
	# TODO: use an existing killtree kind of command to avoid orphans/zombies.
	local pid="$1"
	# debug killing "${pid}"-s children
	# ps -fg "${pid}" >&2
	read -a children < <(ps -fg "${pid}" | sed -e '1 d' | awk '{ print $2 " " $3 }' | sed "/^${pid}/ d" | awk '{ print $1 }')

	debug "about to kill '${pid}' children '${children[@]}'"
	for child in "${children[@]}";
	do
		killPid "${child}"
	done
	debug "killed '${pid}' children '${children[@]}'"
}

isPidRunning() {
	local pid="$1"
	local psInfo=$(ps -o pid= -p "${pid}" | awk '{ print $1 }')

	if (( psInfo == pid ));
	then
		return 0
	else
		return 1
	fi
}

pidFromFile() {
	local pidFile="$1"

	debug "Getting PID from file '${pidFile}'"

	if [[ -e "$pidFile" ]];
	then
		cat "$pidFile"
	else
		# die "could not get pid from non-existant file '${pidFile}'"
		:
	fi
}

isValidPidFile() {
	local pidFile="$1"

	if [[ -s "$pidFile" ]];
	then
		local pid=$(pidFromFile "$pidFile")

		if (( pid > 0 ));
		then
			return 0
		else
			return 1
		fi
	else
		return 2
	fi
}

isPidRunningFromFile() {
	local pidFile="$1"
	local pid=$(pidFromFile "$pidFile")

	[[ -z "${pid}" ]] && die "could not get the pid to check if it's running."

	isPidRunning "$pid"
}

killPidFromFile() {
	local pidFile="$1"
	local pid=$(pidFromFile "$pidFile")

	[[ -z "${pid}" ]] && die "could not get the pid to kill."

	debug "about to kill '${pid}' from '${pidFile}'"
	killPid "$pid"
	debug "killed '${pid}' from '${pidFile}'"
}

killPidFromFileAndWaitUntilDead() {
	local pidFile="$1"
	local pid=$(pidFromFile "$pidFile")

	[[ -z "${pid}" ]] && die "could not get the pid to kill and wait until dead."

	debug "about to kill '${pid}' from '${pidFile}' and wait until dead"
	killPidAndWaitUntilDead "$pid"
	debug "killed '${pid}' from '${pidFile}' and waited until dead"
}

killChildrenFromFile() {
	local pidFile="$1"
	local pid=$(pidFromFile "$pidFile")

	[[ -z "${pid}" ]] && die "could not get the pid to kill child process from."

	killPidChildren "${pid}"
}
