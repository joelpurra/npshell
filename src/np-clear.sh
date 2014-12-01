#!/usr/bin/env bash
set -e

source "${BASH_SOURCE%/*}/shared/functions.sh"
source "${BASH_SOURCE%/*}/shared/functionality.sh"
source "${BASH_SOURCE%/*}/shared/mutexed.sh"

echo -n '' > "$configQueueFile"

# TODO: define a "next" function, as well as for other common user commands.
killExternalPlayerIfRunning
