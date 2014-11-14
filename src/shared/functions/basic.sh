#!/usr/bin/env bash
set -e

isDebugEnabled() {
	[[ "$sharedDebug" == "true" ]]
}

debug() {
	isDebugEnabled && { echo -E "DEBUG: $@" 1>&2; }
	return 0
}

errorMessage() {
	echo -E "play:" "$@" 1>&2
}

die() {
	errorMessage "$@"
	exit 1
	return 1
}

nullAsNewline() {
	tr '\n\0' '\0\n' | "$@" | tr '\0\n' '\n\0'
}

nullDelimitedForEachWithoutEOF() {
	while IFS= read -r -d '' item || true;
	do
		"$@" "$item"
	done
}

nullDelimitedForEachWithEOF() {
	while IFS= read -r -d '' item;
	do
		"$@" "$item"
	done
}

reverseLineOrder() {
	# Use tac, gtac or another detected alternative?
	gtac
}

keepDigitsOnly() {
	sedExtRegexp -e 's/[^[:digit:]]//g' -e '/^$/d'
}
