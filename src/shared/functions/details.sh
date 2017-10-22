#!/usr/bin/env bash
set -e

# TODO: add more sound info tools.
# TODO: use fallback tags -- both id3 v1/v2 and tag names.
# TODO: add other file formats.
soundDetailsExec="$(getFirstExecutable "id3v2")"

executeId3v2List() {
	local sound="$1"
	local soundPath="$sound"

	# NOTE: it's unclear why, but apparently id3v2 sometimes can't seem to find the file upon first attempt.
	# As subsequent calls work fine, this first call will "warm up the cache" so to speak.
	set +e
	id3v2 --list "$soundPath" >/dev/null
	set -e

	id3v2 --list "$soundPath"
}

getSoundDetailArtist() {
	local sound="$1"

	# Fallback value.
	local detail=""

	case "$soundDetailsExec" in
		'id3v2')
			detail=$(executeId3v2List "$sound" | sed -E -n -e '/^TPE1/ s/^[^:]+: (.*)$/\1/ p')
			;;
		*)
			# Do nothing.
			;;
		# TODO: add more sound info tools.
	esac

	echo -E "$detail"
}

getSoundDetailAlbum() {
	local sound="$1"

	# Fallback value.
	local detail=""

	case "$soundDetailsExec" in
		'id3v2')
			detail=$(executeId3v2List "$sound" | sed -E -n -e '/^TALB/ s/^[^:]+: (.*)$/\1/ p')
			;;
		*)
			# Do nothing.
			;;
		# TODO: add more sound info tools.
	esac

	echo -E "$detail"
}

getSoundDetailTitle() {
	local sound="$1"

	# Fallback value.
	local detail=""

	case "$soundDetailsExec" in
		'id3v2')
			detail=$(executeId3v2List "$sound" | sed -E -n -e '/^TIT2/ s/^[^:]+: (.*)$/\1/ p')
			;;
		*)
			# Do nothing.
			;;
		# TODO: add more sound info tools.
	esac

	echo -E "$detail"
}
