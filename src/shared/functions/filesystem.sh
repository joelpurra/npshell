#!/usr/bin/env bash
set -e

resolveDirectory() {
	echo -n "$(cd -- "$1"; echo "$PWD")"
}

# Isn't there a better way to do this? String wise ./ and ../ squisher that doesn't re-parse directories/links?
resolvePath() {
	if [[ -d "$1" ]];
	then
		resolveDirectory "$1"
	else
		echo -n "$(resolveDirectory "$(dirname "$1")")/$(basename -a "$1")"
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

absoluteSoundPaths() {
	local cwd=$(getCwd)

	# Using read seems to be about 7 times slower than sed - why?
	# NOTE: The sed version might be suceptible to improperly escaped characters.
	# TODO: Can be written as a sed replace using \0 instead of nullAsNewline?
	# nullAsNewline sed -e 's|^./||' -e "s|^|$(echo -n -e "${cwd/&/\\&}")/|"

	while IFS= read -r -d '' sound;
	do
		echo -n "${cwd}/${sound/#.\/}"
		echo -n -e "\0"
	done
}

getSoundsInFolder() {
	getOrGenerateSoundCache | absoluteSoundPaths
}

getSounds() {
	if (( $# == 0 ));
	then
		getSoundsInFolder
	else
		local cwd=$(getCwd)

		for soundPath in "$@";
		do
			if [[ -d "${soundPath}" ]];
			then
				# TODO: is pushd/popd better?
				cd -- "${soundPath}"
				getSoundsInFolder
				cd - >/dev/null
			elif [[ -s "${soundPath}" ]];
			then
				echo -n $(resolvePath "${cwd}/${soundPath}")
				echo -n -e "\0"
			else
				errorMessage "could not add the path '${soundPath}' to playlist."
			fi
		done
	fi
}
