#!/usr/bin/env bash
set -e

ensureFoldersAndFilesExist() {
	[[ -e "$configConfigFolder" ]] || mkdir -p "$configConfigFolder"
	[[ -e "$configConfigFile" ]] || touch "$configConfigFile"
	[[ -e "$configQueueFile" ]] || touch "$configQueueFile"
	[[ -e "$configHistoryFile" ]] || touch "$configHistoryFile"
}

readConfig() {
	source "$configConfigFile"
}
