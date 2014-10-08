#!/usr/bin/env bash
set -e

getCdw() {
	echo "$(cd -- "$PWD"; echo "$PWD")"
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
	# Using read seems to be about 7 times slower than sed - why?
	# while IFS= read -r -d '' sound;
	# do
	# 	echo -n "${sharedCwd}/${sound/.\/}"
	# 	echo -n -e "\0"
	# done
	nullAsNewline sed -e 's|^./||' -e "s|^|${sharedCwd}/|"
}

getSounds() {
	getOrGenerateSoundCache | absoluteSoundPaths
}

shuffle() {
	gshuf -z
}

playOrder() {
	if [[ "$sharedOrder" == "random" ]]; then
		shuffle
	elif [[ "$sharedOrder" == "in-order" ]]; then
		cat -
	else
		echo "Unknown order: $sharedOrder" >&2
		exit 1;
	fi
}

play() {
	afplay "$@"
}

highlight() {
	echo "$@" | sed "s|$sharedCwd/||" | grep --extended-regexp --color "/?[^/]+$"
}

nullAsNewline() {
	tr '\n\0' '\0\n' | "$@" | tr '\0\n' '\n\0'
}

limit() {
	if (( sharedNumsounds > 0 )); then
		nullAsNewline head -n "$sharedNumsounds"
	else
		cat -
	fi
}

getNextSound() {
	{ IFS= read -r -d '' sound || true; } < <(head -c 2048 "$sharedQueueFile")
	echo "$sound"
}

progressQueue() {
	echo -n "$(getNextSound)" >> "$sharedHistoryFile"
	echo -n -e "\0" >> "$sharedHistoryFile"
	<"$sharedQueueFile" nullAsNewline sed '1 d' > "${sharedQueueFile}.tmp~"
	mv "${sharedQueueFile}.tmp~" "$sharedQueueFile"
}

exitIfAlreadyRunning() {
	[[ -e "$sharedPidFile" ]] && { echo "play: already running with pid $(cat "$sharedPidFile") according to '$sharedPidFile'." 1>&2; exit 1; }

	trap 'rm -rf "$sharedPidFile"' EXIT
	echo "$$" > "$sharedPidFile"
}

ensureFoldersAndFilesExist() {
	[[ -e "$sharedConfigFolder" ]] || mkdir -p "$sharedConfigFolder"
	[[ -e "$sharedConfigFile" ]] || touch "$sharedConfigFile"
	[[ -e "$sharedQueueFile" ]] || touch "$sharedQueueFile"
	[[ -e "$sharedHistoryFile" ]] || touch "$sharedHistoryFile"
}

readConfig() {
	source "$sharedConfigFile"
}

sharedDefaultConfigFolder="$HOME/.play"
sharedConfigFolder="$sharedDefaultConfigFolder"

sharedDefaultPidFile="${sharedConfigFolder}/.pidfile~"
sharedPidFile="$sharedDefaultPidFile"

sharedDefaultConfigFile="${sharedConfigFolder}/config.sh"
sharedConfigFile="$sharedDefaultConfigFile"

sharedDefaultQueueFile="${sharedConfigFolder}/queue.pls"
sharedQueueFile="$sharedDefaultQueueFile"

sharedDefaultHistoryFile="${sharedConfigFolder}/history.pls"
sharedHistoryFile="$sharedDefaultHistoryFile"

sharedDefaultUseCache=true
sharedUseCache="$sharedDefaultUseCache"

sharedDefaultNumsounds=10
sharedNumsounds="$sharedDefaultNumsounds"

sharedDefaultOrder="random"
sharedOrder="$sharedDefaultOrder"

sharedCacheFile=".play.cache~"

sharedCwd=$(getCdw)

exitIfAlreadyRunning

ensureFoldersAndFilesExist

readConfig