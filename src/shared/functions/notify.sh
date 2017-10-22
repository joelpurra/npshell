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
					-remove "np" \
					-json >/dev/null

				# TODO: use the JSON output if the user clicks close/show/custom action?
				# The closeLabel and alert actions are only shown if the user allows it to.
				# - Open System Preferences > Notification.
				# - Select "terminal-notifier" (or perhaps "np") in the sidebar.
				# - Select the "Alerts" alert style.
				# https://github.com/julienXX/terminal-notifier/raw/master/assets/System_prefs.png
				#
				# NOTE: Setting timeout due to bug in terminal-notifier.
				# https://github.com/julienXX/terminal-notifier/issues/223
				#
				# NOTE: escaping the first character of title/subtitle/message, despite the bug being fixed.
				# https://github.com/julienXX/terminal-notifier/issues/11
				terminal-notifier \
					-group "np" \
					-title "\\${title}" \
					-open "https://github.com/joelpurra/npshell" \
					-subtitle "\\${subtitle}" \
					-message "\\${message}" \
					-timeout "$configNotificationTimeout" \
					-json >/dev/null
			)  &
			;;
		'growlnotify')
			# http://growl.info/downloads
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
