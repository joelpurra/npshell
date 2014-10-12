#!/usr/bin/env bash
set -e

source "${BASH_SOURCE%/*}/play-shared-functions.sh"
source "${BASH_SOURCE%/*}/play-shared-functionality.sh"
source "${BASH_SOURCE%/*}/play-shared-functionality-mutexed.sh"

if isValidStrictlyPositiveNumber "$1";
then
	sharedNumsounds="${1:-$sharedNumsounds}"
	shift
fi

if isValidPlayOrder "$1";
then
	sharedOrder="${1:-$sharedOrder}"
	shift
fi

getSounds | playOrder | limit | absoluteSoundPaths >> "$sharedQueueFile"
