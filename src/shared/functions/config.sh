#!/usr/bin/env bash
set -e

ensureConfigFoldersAndFilesExist() {
	[[ -d "$configConfigFolder" ]] || mkdir -p "$configConfigFolder"
	[[ -e "$configConfigFile" ]] || touch "$configConfigFile"
}

ensureOtherFoldersAndFilesExist() {
	[[ -e "$configQueueFile" ]] || touch "$configQueueFile"
	[[ -e "$configHistoryFile" ]] || touch "$configHistoryFile"
}

readConfig() {
	debug "Reading configuration file '${configConfigFile}'"
	[[ -e "$configConfigFile" ]] && source "$configConfigFile"
}
