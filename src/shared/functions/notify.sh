#!/usr/bin/env bash
set -e

# TODO: add more notifiers.
# TODO: add support for node-notifier when available.
# https://github.com/mikaelbr/node-notifier/blob/master/DECISION_FLOW.md
# https://github.com/mikaelbr/node-notifier/issues/40
notifyExec="$(getFirstExecutable "terminal-notifier" "growlnotify")"

killNotifications() {
	if [[ -s "$configNotifyPidFile" ]];
	then
		killPidFromFileAndWaitUntilDead "$configNotifyPidFile"
	fi

	return 0
}

isNotificationsRunning() {
	if isValidPidFileAndRunningOrCleanup "$configNotifyPidFile";
	then
		return 0
	else
		return 1
	fi
}

killNotificationsIfRunning() {
	{ isNotificationsRunning && killNotifications; } || true &>/dev/null

	return 0
}

notify() {
	local title="$1"
	shift
	local subtitle="$1"
	shift
	local message="$1"
	shift

	case "$notifyExec" in
		'terminal-notifier')
			# Currently not awaiting exit/output as it depends on the configurable timeout.
			(
				# NOTE: forcefully close any previous notification, in case it wasn't already gone.
				terminal-notifier \
					-remove "np" >/dev/null

				# NOTE: need to escaping the first character of title/subtitle/message; at least special characters such as square brackets '['.
				terminal-notifier \
					-group "np" \
					-title "\\${title}" \
					-open "https://github.com/joelpurra/npshell" \
					-subtitle "\\${subtitle}" \
					-message "\\${message}" >/dev/null
			) &
			;;
		'growlnotify')
			# https://growl.github.io/growl/
			# Untested.
			# Does not seem to support a timeout argument.
			growlnotify \
				--noteName "${title} - ${subtitle}" \
				--identifier "np" \
				--url "https://github.com/joelpurra/npshell" \
				--message "$message" >/dev/null
			;;
		*)
			die "no notifier executable found."
			;;
		# TODO: add more notifiers.
	esac
}
