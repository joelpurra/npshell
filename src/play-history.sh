#!/usr/bin/env bash
set -e

source "${BASH_SOURCE%/*}/shared/functions.sh"
source "${BASH_SOURCE%/*}/shared/functionality.sh"
source "${BASH_SOURCE%/*}/shared/mutexed.sh"

while IFS= read -r -d '' sound || true;
do
	highlight "$sound"
done < <(cat "$sharedHistoryFile")