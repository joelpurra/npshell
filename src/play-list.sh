#!/usr/bin/env bash
set -e

source "${BASH_SOURCE%/*}/play-shared-functions.sh"
source "${BASH_SOURCE%/*}/play-shared-functionality.sh"
source "${BASH_SOURCE%/*}/play-shared-functionality-mutexed.sh"

while IFS= read -r -d '' sound || true;
do
	highlight "$sound"
done < <(cat "$sharedQueueFile")