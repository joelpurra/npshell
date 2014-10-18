#!/usr/bin/env bash
set -e

highlight() {
	local cwd=$(getCwd)

	echo -E "$@" | sed "s|^${cwd}/||" | grep --extended-regexp --color "/?[^/]+$"
}

highlightAll() {
		nullDelimitedForEachWithEOF highlight
}
