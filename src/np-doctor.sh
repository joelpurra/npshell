#!/usr/bin/env bash
set -e

source "${BASH_SOURCE%/*}/shared/functions.sh"
source "${BASH_SOURCE%/*}/shared/functionality.sh"
source "${BASH_SOURCE%/*}/shared/mutexed.sh"

echo "Configuration: $configConfigFolder"

echo "External player: '$externalPlayerExec'"
echo "fswatch: '$fswatchExec'"
echo "Shuffler: '$externalShuffleExec'"
echo "Line reverser: '$reverseLineOrderExec'"

echo "Mode: $(cat "$configModeFile")"

echo -n "Daemon: "
if isValidPidFile "$configDaemonPidFile" && isPidRunningFromFile "$configDaemonPidFile";
then
	echo "running (pid $(cat "$configDaemonPidFile" ))"
else
	echo "stopped"
fi

echo -n "External player: "
if isValidPidFile "$configExternalPlayerPidFile" && isPidRunningFromFile "$configExternalPlayerPidFile";
then
	echo "running (pid $(cat "$configExternalPlayerPidFile" ))"

	echo -n "Sound: "
	highlight "$(cat "$configPlayingFile")" || echo
else
	echo "stopped"
fi
