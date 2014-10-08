#!/usr/bin/env bash
set -e

source "${BASH_SOURCE%/*}/play-shared-functionality.sh"

echo -n '' > "$sharedQueueFile"
