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

reverseLineOrder() {
	"$(getFirstExecutable "tac" "gtac" "/usr/local/bin/gtac")"
}

keepDigitsOnly() {
	sedExtRegexp -e 's/[^[:digit:]]//g' -e '/^$/d'
}
