#!/usr/bin/env bash
set -e

highlight() {
	local cwd=$(getCwd)

	echo -E "$@" | sed "s|^${cwd}/||" | grep --extended-regexp --color "/?[^/]+$"
}

highlightAll() {
		nullDelimitedForEachWithEOF highlight
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
