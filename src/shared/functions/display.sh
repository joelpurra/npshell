#!/usr/bin/env bash
set -e

highlight() {
	local cwd=$(getCwd)

	echo "$@" | sed "s|^${cwd}/||" | grep --extended-regexp --color "/?[^/]+$"
}

highlightAll() {
	while IFS= read -r -d '' sound || true;
	do
		highlight "$sound"
	done
}
