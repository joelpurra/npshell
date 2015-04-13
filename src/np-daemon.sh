#!/usr/bin/env bash
set -e

source "${BASH_SOURCE%/*}/shared/functions.sh"
source "${BASH_SOURCE%/*}/shared/functionality.sh"

if [[ "$1" == "--is-running" ]];
then
	if isDaemonRunning;
	then
		exit 0
	else
		exit 1
	fi
fi

if [[ "$1" == "--stop" ]];
then
	killDaemonIfRunning
	killExternalPlayerIfRunning
	exit 0
fi

exitIfAlreadyRunning "$configDaemonPidFile" "daemon"
savePidButDeleteOnExit "daemon" "$$" "$configDaemonPidFile"

verboseOutput="false"
if [[ "$1" == "--verbose" ]];
then
	shift || true
	verboseOutput="true"
fi

whenQueueOrModeIsChanged() {
	waitForFileChange "$configQueueFile" "$configModeFile"
}

daemonLoop() {
	while true;
	do
		checkMode || whenQueueOrModeIsChanged
	done
}

daemonLoop
