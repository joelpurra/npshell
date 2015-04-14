#!/usr/bin/env bash
set -e

source "${BASH_SOURCE%/*}/shared/functions.sh"
source "${BASH_SOURCE%/*}/shared/functionality.sh"
source "${BASH_SOURCE%/*}/shared/mutexed.sh"

displayMessage "Configuration: $configConfigFolder"


displayMessage "External player: '$externalPlayerExec'"
displayMessage "fswatch: '$fswatchExec'"
displayMessage "Shuffler: '$externalShuffleExec'"
displayMessage "Line reverser: '$reverseLineOrderExec'"
displayMessage "Notifications: '$notifyExec'"


displayMessage "Mode: $(cat "$configModeFile")"


displayMessage -n "Daemon: "
if isValidPidFileAndRunningOrCleanup "$configDaemonPidFile";
then
	displayMessage "running (pid $(cat "$configDaemonPidFile" ))"
else
	displayMessage "stopped"
fi


displayMessage -n "Notifications: "
if isValidPidFileAndRunningOrCleanup "$configNotifyPidFile";
then
	displayMessage "running (pid $(cat "$configNotifyPidFile" ))"
else
	displayMessage "stopped"
fi


displayMessage -n "External player: "
if isExternalPlayerRunning;
then
	displayMessage "running (pid $(cat "$configExternalPlayerPidFile" ))"

	displayMessage -n "Sound: "
	highlight "$(cat "$configPlayingFile")" || displayMessage
else
	displayMessage "stopped"
fi
