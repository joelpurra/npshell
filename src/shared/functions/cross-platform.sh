#!/usr/bin/env bash
set -e

externalExecutableExists() {
	local executable="$1"

	if builtin type "$executable" &>/dev/null;
	then
		return 0
	else
		return 1
	fi
}

getFirstExecutable() {
	debug "Finding first executable in \$PATH out of '$@'"

	local path=""

	for executable in "$@";
	do
		if externalExecutableExists "$executable";
		then
			path="$executable"
			break
		fi
	done

	debug "First executable is '${path}'"

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

fswatchExec="$(getFirstExecutable "fswatch" "/usr/local/bin/fswatch")"

waitForFileChange() {
	# https://github.com/emcrisostomo/fswatch
	# Should cover all systems
	[[ -z "$fswatchExec" ]] && die "could not find 'fswatch'"

	debug "Waiting for change in '$@': '$watched'"

	local watched=$("$fswatchExec" --one-event "$@")

	debug "Detected change in '$@': '$watched'"
}

# http://stackoverflow.com/questions/17878684/best-way-to-get-file-modified-time-in-seconds
# http://stackoverflow.com/a/17907126/
if stat -c %Y . >/dev/null 2>&1; then
    get_modified_time() { stat -c %Y "$1" 2>/dev/null; }
elif stat -f %m . >/dev/null 2>&1; then
    get_modified_time() { stat -f %m "$1" 2>/dev/null; }
elif date -r . +%s >/dev/null 2>&1; then
    get_modified_time() { stat -r "$1" +%s 2>/dev/null; }
else
    echo 'get_modified_time() is unsupported' >&2
    get_modified_time() { printf '%s' 0; }
fi

getLastFileModifiedTime() {
	echo $(get_modified_time "$1")
}
