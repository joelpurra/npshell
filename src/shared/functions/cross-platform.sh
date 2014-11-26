#!/usr/bin/env bash
set -e

getFirstExecutable() {
	debug "Finding first executable in \$PATH out of '$@'"

	local path=""

	for executable in "$@";
	do
		if [[ -n $(which "$executable") ]];
		then
			path="$executable"
			break
		fi
	done

	debug "First executable is '$path'"

	echo -nE "$path"
}

# External player detection.
# TODO: confirm and expand list.
externalPlayerExec="$(getFirstExecutable "afplay" "mplayer" "mpg123" "mpg321" "play")"

# External player detection.
# TODO: confirm and expand list.
externalShuffleExec="$(getFirstExecutable "shuf" "gshuf")"

# From https://github.com/EtiennePerot/parcimonie.sh/blob/master/parcimonie.sh
# Test for GNU `sed`, or use a `sed` fallback in sedExtRegexp
sedExec=(sed)
if [ "$(echo 'abc' | sed -r 's/abc/def/' 2> /dev/null || true)" == 'def' ]; then
	# GNU Linux sed
	sedExec+=(-r)
else
	# Mac OS X sed
	sedExec+=(-E)
fi

sedExtRegexp() {
	"${sedExec[@]}" "$@"
}
