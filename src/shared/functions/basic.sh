#!/usr/bin/env bash
set -e

isDebugEnabled() {
	[[ "$sharedDebug" == "true" ]]
}

debug() {
	isDebugEnabled && { echo "DEBUG: $@" 1>&2; }
	return 0
}

errorMessage() {
	echo "play:" "$@" 1>&2
}

die() {
	errorMessage "$@"
	exit 1
	return 1
}

nullAsNewline() {
	tr '\n\0' '\0\n' | "$@" | tr '\0\n' '\n\0'
}