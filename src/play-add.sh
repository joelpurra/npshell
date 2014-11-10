#!/usr/bin/env bash
set -e

source "${BASH_SOURCE%/*}/shared/functions.sh"
source "${BASH_SOURCE%/*}/shared/functionality.sh"
source "${BASH_SOURCE%/*}/shared/mutexed.sh"

if isValidStrictlyPositiveNumber "$1";
then
	sharedNumsounds="${1:-$sharedNumsounds}"
	shift
elif isValidNumsoundsOverride "$1";
then
	sharedNumsounds=-1
	shift
fi

if isValidPlayOrder "$1";
then
	sharedOrder="${1:-$sharedOrder}"
	shift
fi

getLineCount() {
	wc -l | keepDigitsOnly
}

saveLineCount() {
	IFS= read -r -d '' lineCount;
}

declare -i lineCount=$(getSounds "$@" | playOrder | limit | tee -a "$sharedQueueFile" | nullAsNewline getLineCount)
cat "$sharedQueueFile" | nullAsNewline numberLines | nullAsNewline tail -n "$lineCount" | highlightAllWithLineNumbers

echo "Added $lineCount sounds."
