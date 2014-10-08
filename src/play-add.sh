#!/usr/bin/env bash
set -e

source "${BASH_SOURCE%/*}/play-shared-functionality.sh"

sharedNumsounds="${1:-$sharedDefaultNumsounds}"
sharedOrder="${2:-$sharedDefaultOrder}"

getOrGenerateSoundCache | playOrder | limit >> "$sharedQueueFile"
