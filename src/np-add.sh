#!/usr/bin/env bash
set -e

source "${BASH_SOURCE%/*}/shared/functions.sh"
source "${BASH_SOURCE%/*}/shared/functionality.sh"
source "${BASH_SOURCE%/*}/shared/mutexed.sh"

if isValidStrictlyPositiveNumber "$1";
then
	configNumsounds="${1:-$configNumsounds}"
	shift
elif isValidNumsoundsOverride "$1";
then
	configNumsounds=-1
	shift
fi

if isValidPlayOrder "$1";
then
	configOrder="${1:-$configOrder}"
	shift
fi

getLineCount() {
	wc -l | keepDigitsOnly
}

declare -i lineCount=$(getSounds "$@" | playOrder | limit | tee -a "$configQueueFile" | nullAsNewline getLineCount)
cat "$configQueueFile" | nullAsNewline numberLines | nullAsNewline tail -n "$lineCount" | highlightAllWithLineNumbers

echo "Added ${lineCount} sounds."
