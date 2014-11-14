#!/usr/bin/env bash
set -e

resolveDirectory() {
	(cd -- "$1"; echo -nE "$PWD")
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

	echo -nE "${base}/${sound/#.\/}"
	echo -ne "\0"
}

absoluteSoundPaths() {
	local cwd=$(getCwd)

	# Using read seems to be about 7 times slower than sed - why?
	# NOTE: The sed version might be suceptible to improperly escaped characters.
	# TODO: Can be written as a sed replace using \0 instead of nullAsNewline?
	# nullAsNewline sed -e 's|^./||' -e "s|^|$(echo -ne "${cwd/&/\\&}")/|"

	nullDelimitedForEachWithEOF absoluteSoundPath "$cwd"
}

getSoundsInFolder() {
	getOrGenerateSoundCache | absoluteSoundPaths
}

getSoundFromFile() {
	local cwd=$(getCwd)

	absoluteSoundPath "$cwd" "$soundPath"
}

getSoundsFromFolderOrFile() {
	local soundPath="$1"

	if [[ -d "$soundPath" ]];
	then
		pushd "$soundPath" >/dev/null
		getSoundsInFolder
		popd >/dev/null
	elif [[ -s "$soundPath" ]];
	then
		getSoundFromFile "$soundPath"
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
			if [[ "$soundPath" == "-" ]];
			then
				nullDelimitedForEachWithEOF getSoundsFromFolderOrFile
			else
				getSoundsFromFolderOrFile "$soundPath"
			fi
		done
	fi
}