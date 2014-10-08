#!/usr/bin/env bash
set -e

source "${BASH_SOURCE%/*}/play-shared-functionality.sh"

while IFS= read -r -d '' sound || true;
do
	highlight "$sound"
done < <(cat "$sharedQueueFile")