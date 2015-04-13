#!/usr/bin/env bash
set -e

ensureConfigFoldersAndFilesExist() {
	[[ -d "$configConfigFolder" ]] || mkdir -p "$configConfigFolder"
	[[ -e "$configConfigFile" ]] || touch "$configConfigFile"
}

ensureOtherFoldersAndFilesExist() {
	[[ -e "$configQueueFile" ]] || touch "$configQueueFile"
	[[ -e "$configHistoryFile" ]] || touch "$configHistoryFile"
	[[ -e "$configPlayingFile" ]] || touch "$configPlayingFile"

	# This makes the daemon start playing immidiately on first run, or if the mode file was deleted.
	[[ -e "$configModeFile" ]] || echo "playing" > "$configModeFile"
}

readConfig() {
	debug "Reading configuration file '${configConfigFile}'"
	[[ -e "$configConfigFile" ]] && source "$configConfigFile"
}
