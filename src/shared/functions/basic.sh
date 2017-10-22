#!/usr/bin/env bash
set -e

nullAsNewline() {
	tr '\n\0' '\0\n' | "$@" | tr '\0\n' '\n\0'
}

nullDelimitedForEachWithoutEOF() {
	while IFS= read -r -d '' item || true;
	do
		"$@" "$item"
	done
}

nullDelimitedForEachWithEOF() {
	while IFS= read -r -d '' item;
	do
		"$@" "$item"
	done
}

reverseLineOrderExec="$(getFirstExecutable "tac" "gtac" "/usr/local/bin/gtac")"

reverseLineOrder() {
	"$reverseLineOrderExec"
}

keepDigitsOnly() {
	sedExtRegexp -e 's/[^[:digit:]]//g' -e '/^$/d'
}

trim () {
	# https://stackoverflow.com/questions/4422491/how-do-i-trim-lines-read-from-standard-input-on-bash
	local line;
	read -r line;
	echo "$line";
}
