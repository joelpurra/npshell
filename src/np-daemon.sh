#!/usr/bin/env bash
set -e

source "${BASH_SOURCE%/*}/shared/functions.sh"
source "${BASH_SOURCE%/*}/shared/functionality.sh"

if [[ "$1" == "--stop" ]];
then
	killPidFromFile "$configDaemonPidFile"
	killExternalPlayerIfRunning
	exit 0
fi

exitIfAlreadyRunning "$configDaemonPidFile" "daemon"
savePidButDeleteOnExit "daemon" "$$" "$configDaemonPidFile"

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
