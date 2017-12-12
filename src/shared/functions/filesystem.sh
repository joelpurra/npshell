#!/usr/bin/env bash
set -e

function crossplatformReadlink {
	# NOTE: this function has been duplicated elsewhere in this project.
	# https://stackoverflow.com/questions/1055671/how-can-i-get-the-behavior-of-gnus-readlink-f-on-a-mac
	# https://stackoverflow.com/a/1116890
	TARGET_FILE="$1"

	cd "$(dirname "$TARGET_FILE")"
	TARGET_FILE="$(basename "$TARGET_FILE")"

	# Iterate down a (possible) chain of symlinks
	while [ -L "$TARGET_FILE" ]
	do
	    TARGET_FILE="$(readlink "$TARGET_FILE")"
	    cd "$(dirname "$TARGET_FILE")"
	    TARGET_FILE="$(basename "$TARGET_FILE")"
	done

	# Compute the canonicalized name by finding the physical path
	# for the directory we're in and appending the target file.
	PHYS_DIR="$(pwd -P)"
	RESULT="${PHYS_DIR}/${TARGET_FILE}"
	echo "$RESULT"
}

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
	find . \( -not -path '/.*' \) -name '*.mp3' -print0
}

generateSoundCache() {
	allsounds >"$configCacheFileName"
}

soundCacheExists() {
	if [[ -e "$configCacheFileName" ]];
	then
		return 0
	else
		return 1
	fi
}

getOrGenerateSoundCache() {
	if [[ "$configUseCache" == "false" ]];
	then
		allsounds
	else
		soundCacheExists || generateSoundCache

		cat "$configCacheFileName"
	fi
}

deleteSoundCache() {
	rm -- "$configCacheFileName"
}

deleteSoundCacheRecursively() {
	find . -name "$configCacheFileName" -delete
}

absoluteSoundPath() {
	local base="$1"
	local sound="$2"

	if [[ "${sound:0:1}" == "/" ]];
	then
		echo -nE "${sound/#.\/}"
	else
		echo -nE "${base}/${sound/#.\/}"
	fi

	echo -ne "\0"
}

absoluteSoundPaths() {
	local cwd="$(getCwd)"

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
	local cwd="$(getCwd)"

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
		if [[ -L "$soundPath" ]];
		then
			errorMessage "could not add the symlink path '${soundPath}' to playlist."
		else
			errorMessage "could not add the path '${soundPath}' to playlist."
		fi
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
