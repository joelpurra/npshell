#!/usr/bin/env bash
set -e

# TODO: add more notifiers.
# TODO: add support for node-notifier when available.
# https://github.com/mikaelbr/node-notifier/blob/master/DECISION_FLOW.md
# https://github.com/mikaelbr/node-notifier/issues/40
notifyExec="$(getFirstExecutable "terminal-notifier" "growlnotify")"

cleanupNotifications() {
	if [[ -e "$configNotifyPidFile" ]];
	then
		rm "$configNotifyPidFile"
	fi

	return 0
}

killNotifications() {
	if [[ -s "$configNotifyPidFile" ]];
	then
		killPidFromFileAndWaitUntilDead "$configNotifyPidFile"
	fi

	return 0
}

isNotificationsRunning() {
	if isValidPidFile "$configNotifyPidFile" && isPidRunningFromFile "$configNotifyPidFile";
	then
		return 0
	else
		return 1
	fi
}

killNotificationsIfRunning() {
	{ isNotificationsRunning && killNotifications; } || true &>/dev/null
}

notify() {
	[[ -z "$notifyExec" ]] && die "no notifier executable found."

	local subtitle="$1"
	shift
	local message="$1"
	shift

	case "$notifyExec" in
		'terminal-notifier')
			terminal-notifier -title "np" -group "np" -open "https://github.com/joelpurra/npshell" -subtitle "$subtitle" -message "$message"
			;;
		'growlnotify')
			# Untested.
			growlnotify --noteName "np: $subtitle" --identifier "np" --url "https://github.com/joelpurra/npshell" --message "$message"
			;;
		# TODO: add more notifiers.
	esac
}
