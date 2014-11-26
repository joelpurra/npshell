#!/usr/bin/env bash
set -e

isDebugEnabled() {
	[[ "$configDebug" == "true" ]]
}

debug() {
	if isDebugEnabled;
	then
		echo -ne "($$)\t" 1>&2
		echo -E "DEBUG: $@" 1>&2
	fi

	return 0
}

errorMessage() {
	echo -E "np:" "$@" 1>&2
}

die() {
	errorMessage "$@"
	exit 1
	return 1
}
