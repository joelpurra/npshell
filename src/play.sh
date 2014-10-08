#!/usr/bin/env bash
set -e

defaultNumsongs=10
numsongs="${1:-$defaultNumsongs}"

defaultOrder="random"
order="${2:-$defaultOrder}"

cacheFile=".play.cache~"

cwd="$(cd -- "$PWD"; echo "$PWD")"

allsongs() {
	find "$cwd" -name '*.mp3' -print0
}

getOrGenerateSongCache(){
	[[ -e "$cacheFile" ]] || { allsongs >"$cacheFile"; }

	cat "$cacheFile"
}

shuffle() {
	gshuf -z
}

playOrder(){
	if [[ "$order" == "random" ]]; then
		shuffle
	elif [[ "$order" == "in-order" ]]; then
		cat -
	else
		echo "Unknown order: $order" >&2
		exit 1;
	fi
}

play() {
	afplay "$@"
}

highlight(){
	echo "$@" | sed "s|$cwd/||" | grep --extended-regexp --color "/?[^/]+$"
}

nullAsNewline(){
        tr '\n\0' '\0\n' | "$@" | tr '\0\n' '\n\0'
}

limit(){
	if (( numsongs > 0 )); then
	        nullAsNewline head -n "$numsongs"
	else
		cat -
	fi
}

while IFS= read -r -d '' song;
do
	highlight "$song"
	(trap 'echo -n' SIGINT; { play "$song" || true; } )
	echo -ne '\r'
done < <(getOrGenerateSongCache | playOrder | limit)
