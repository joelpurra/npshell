#!/usr/bin/env bash
set -e

source "${BASH_SOURCE%/*}/play-shared-functions.sh"
source "${BASH_SOURCE%/*}/play-shared-functionality.sh"
source "${BASH_SOURCE%/*}/play-shared-functionality-mutexed.sh"

sharedNumsounds="${1:-$sharedNumsounds}"
sharedOrder="${2:-$sharedOrder}"

getSounds | playOrder | limit >> "$sharedQueueFile"
