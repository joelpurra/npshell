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

getId3v1Frame() {
	local frame="$1"

	sed -E -n -e "/^.*${frame} *: */ {
		s/^.*${frame} *: *(.+)   .*$/\1/
		s/   *.*//
		p
	}" | trim
}

getId3v2Frame() {
	local frame="$1"

	sed -E -n -e "/^${frame} / s/^[^:]+: (.*)\$/\\1/ p" | trim
}

getSoundDetailArtist() {
	local sound="$1"

	# Fallback value.
	local detail=""

	case "$soundDetailsExec" in
		'id3v2')
			detail=$(executeId3v2List "$sound" | getId3v2Frame "TPE1")

			if [[ -z "$detail" ]];
			then
				detail=$(executeId3v2List "$sound" | getId3v2Frame "TPE2")
			fi

			if [[ -z "$detail" ]];
			then
				detail=$(executeId3v2List "$sound" | getId3v2Frame "TPE3")
			fi

			if [[ -z "$detail" ]];
			then
				detail=$(executeId3v2List "$sound" | getId3v2Frame "TPE4")
			fi

			if [[ -z "$detail" ]];
			then
				detail=$(executeId3v2List "$sound" | getId3v2Frame "TOPE")
			fi

			# NOTE: variations of frames found while testing.
			if [[ -z "$detail" ]];
			then
				detail=$(executeId3v2List "$sound" | getId3v2Frame "TP1")
			fi

			if [[ -z "$detail" ]];
			then
				detail=$(executeId3v2List "$sound" | getId3v2Frame "TP2")
			fi

			if [[ -z "$detail" ]];
			then
				detail=$(executeId3v2List "$sound" | getId3v2Frame "TP3")
			fi

			if [[ -z "$detail" ]];
			then
				detail=$(executeId3v2List "$sound" | getId3v2Frame "TP4")
			fi

			# NOTE: parsing id3v1.
			if [[ -z "$detail" ]];
			then
				detail=$(executeId3v2List "$sound" | getId3v1Frame "Artist")
			fi
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
			detail=$(executeId3v2List "$sound" | getId3v2Frame "TALB")

			if [[ -z "$detail" ]];
			then
				detail=$(executeId3v2List "$sound" | getId3v2Frame "TOAL")
			fi

			if [[ -z "$detail" ]];
			then
				detail=$(executeId3v2List "$sound" | getId3v2Frame "TAL")
			fi

			# NOTE: parsing id3v1.
			if [[ -z "$detail" ]];
			then
				detail=$(executeId3v2List "$sound" | getId3v1Frame "Album")
			fi
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
			detail=$(executeId3v2List "$sound" | getId3v2Frame "TIT1")

			if [[ -z "$detail" ]];
			then
				detail=$(executeId3v2List "$sound" | getId3v2Frame "TIT2")
			fi

			if [[ -z "$detail" ]];
			then
				detail=$(executeId3v2List "$sound" | getId3v2Frame "TIT3")
			fi

			# NOTE: variations of frames found while testing.
			if [[ -z "$detail" ]];
			then
				detail=$(executeId3v2List "$sound" | getId3v2Frame "TT1")
			fi

			if [[ -z "$detail" ]];
			then
				detail=$(executeId3v2List "$sound" | getId3v2Frame "TT2")
			fi

			if [[ -z "$detail" ]];
			then
				detail=$(executeId3v2List "$sound" | getId3v2Frame "TT3")
			fi

			# NOTE: parsing id3v1.
			if [[ -z "$detail" ]];
			then
				detail=$(executeId3v2List "$sound" | getId3v1Frame "Title")
			fi
			;;
		*)
			# Do nothing.
			;;
		# TODO: add more sound info tools.
	esac

	echo -E "$detail"
}
