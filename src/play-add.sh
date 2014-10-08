#!/usr/bin/env bash
set -e

source "${BASH_SOURCE%/*}/play-shared-functionality.sh"

sharedNumsounds="${1:-$sharedNumsounds}"
sharedOrder="${2:-$sharedOrder}"

getSounds | playOrder | limit >> "$sharedQueueFile"
