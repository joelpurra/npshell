#!/usr/bin/env bash
set -e

resolveDirectory() {
	(cd -- "$1"; echo -n "$PWD")
}

# Isn't there a better way to do this? String wise ./ and ../ squisher that doesn't re-parse directories/links?
resolvePath() {
	if [[ -d "$1" ]];
	then
		resolveDirectory "$1"
	else
		resolveDirectory "$(dirname "$1")/$(basename -a "$1")"
	fi
}

getCwd() {
	resolveDirectory "$PWD"
}

allsounds() {
	find . -name '*.mp3' -print0
}

getOrGenerateSoundCache() {
	if [[ "$sharedUseCache" == "false" ]];
	then
		allsounds
	else
		[[ -e "$sharedCacheFile" ]] || { allsounds >"$sharedCacheFile"; }

		cat "$sharedCacheFile"
	fi
}

absoluteSoundPath() {
	local base="$1"
	local sound="$2"

	echo -n -E "${base}/${sound/#.\/}"
	echo -n -e "\0"
}

absoluteSoundPaths() {
	local cwd=$(getCwd)

	# Using read seems to be about 7 times slower than sed - why?
	# NOTE: The sed version might be suceptible to improperly escaped characters.
	# TODO: Can be written as a sed replace using \0 instead of nullAsNewline?
	# nullAsNewline sed -e 's|^./||' -e "s|^|$(echo -n -e "${cwd/&/\\&}")/|"

	nullDelimitedForEachWithEOF absoluteSoundPath "$cwd"
}

getSoundsInFolder() {
	getOrGenerateSoundCache | absoluteSoundPaths
}

getSoundsFromFolderOrFile() {
	local cwd=$(getCwd)
	local soundPath="$1"

	if [[ -d "${soundPath}" ]];
	then
		pushd "${soundPath}"
		getSoundsInFolder
		popd
	elif [[ -s "${soundPath}" ]];
	then
		resolvePath "${cwd}/${soundPath}"
		echo -n -e "\0"
	else
		errorMessage "could not add the path '${soundPath}' to playlist."
	fi
}

getSounds() {
	if (( $# == 0 ));
	then
		getSoundsInFolder
	else
		for soundPath in "$@";
		do
			getSoundsFromFolderOrFile "$soundPath"
		done
	fi
}
