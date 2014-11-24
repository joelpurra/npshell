#!/usr/bin/env bash
set -e

source "${BASH_SOURCE%/*}/shared/functions.sh"
source "${BASH_SOURCE%/*}/shared/functionality.sh"
source "${BASH_SOURCE%/*}/shared/mutexed.sh"

tmpQueueFile="$sharedQueueFile.tmp~"

skipNonexistantFiles() {
	sound="$1"

	debug "clean: checking '${sound}'."


	if [[ -s "${sound}" ]];
	then
		debug "clean: kept existing sound '${sound}' in queue."
		echo -nE "${sound}"
		echo -ne "\0"
	else
		debug "clean: removed sound '${sound}' from queue."
	fi
}

cat "$sharedQueueFile" | nullDelimitedForEachWithEOF skipNonexistantFiles > "$tmpQueueFile"
mv -f "$tmpQueueFile" "$sharedQueueFile"