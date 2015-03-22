#!/usr/bin/env bash
set -e

displayMessage() {
	echo "$@"
}

highlight() {
	if (("$#" == 2 ));
	then
		local cwd="$1"
		local line="$2"
	elif (("$#" == 1 ));
	then
		local cwd=$(getCwd)
		local line="$1"
	else
		die "wrong number of highlight arguments"
	fi

	displayMessage -E "$line" | sed "s|^${cwd}/||" | grep --extended-regexp --color "/?[^/]+$"
}

highlightAll() {
	nullDelimitedForEachWithEOF highlight "$cwd"
}

highlightWithLineNumbers() {
	if (("$#" == 2 ));
	then
		local cwd="$1"
		local line="$2"
	elif (("$#" == 1 ));
	then
		local cwd=$(getCwd)
		local line="$1"
	else
		die "wrong number of highlight arguments"
	fi

	displayMessage -E "$line" | sedExtRegexp "s|^([[:space:]]*-?[[:digit:]]+[[:space:]]+)${cwd}/|\1|" | grep --extended-regexp --color "/?[^/]+$"
}

highlightAllWithLineNumbers() {
	local cwd=$(getCwd)

	nullDelimitedForEachWithEOF highlightWithLineNumbers "$cwd"
}

removeNumberingSpacesFromEachLine() {
	sed -e 's/^   //g' -e 's/^\( *[[:digit:]][[:digit:]]*\)\	/\1 /g'
}

addNegativeSignBeforeLineNumber() {
	sed 's/^\( *\)\([[:digit:]][[:digit:]]*\)/\1-\2/g'
}

numberLines() {
	cat -n | removeNumberingSpacesFromEachLine
}

numberLinesReverse() {
	reverseLineOrder | numberLines | addNegativeSignBeforeLineNumber | reverseLineOrder
}
