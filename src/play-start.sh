#!/usr/bin/env bash
set -e

source "${BASH_SOURCE%/*}/play-shared-functionality.sh"

sound=$(getNextSound)
[[ -z "$sound" ]] && { echo "play: no sounds in queue." 1>&2; exit 1; }

while true;
do
	sound=$(getNextSound)
	[[ -z "$sound" ]] && { exit 1; }
	[[ -s "$sound" ]] || { echo "play: sound not found: '$sound'." 1>&2; exit 1; }
	highlight "$sound"
	(trap 'echo -n' SIGINT; { play "$sound" || true; } )
	echo -ne '\r'
	progressQueue
done