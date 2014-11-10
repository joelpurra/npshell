#!/usr/bin/env bash
set -e

source "${BASH_SOURCE%/*}/shared/functions.sh"
source "${BASH_SOURCE%/*}/shared/functionality.sh"
source "${BASH_SOURCE%/*}/shared/mutexed.sh"

skipNonexistantFiles() {
	[[ -s "$1" ]] && { echo -nE "$1"; echo -ne "\0"; }
}

{ cat "$sharedQueueFile" | nullDelimitedForEachWithEOF skipNonexistantFiles > "$sharedQueueFile.tmp~"; } && mv "$sharedQueueFile.tmp~" "$sharedQueueFile"