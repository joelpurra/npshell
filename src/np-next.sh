#!/usr/bin/env bash
set -e

source "${BASH_SOURCE%/*}/shared/functions.sh"
source "${BASH_SOURCE%/*}/shared/functionality.sh"
source "${BASH_SOURCE%/*}/shared/mutexed.sh"

if isExternalPlayerRunning;
then
	killExternalPlayerIfRunning
else
	progressQueue
fi
