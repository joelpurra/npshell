#!/usr/bin/env bash
set -e

source "${BASH_SOURCE%/*}/shared/functions.sh"
source "${BASH_SOURCE%/*}/shared/functionality.sh"
source "${BASH_SOURCE%/*}/shared/mutexed.sh"

mode=$(getMode)

if [[ "$mode" == "playing" ]];
then
	setModeStop
else
	setModeStart
fi
