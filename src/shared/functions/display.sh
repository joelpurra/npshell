#!/usr/bin/env bash
set -e

highlight() {
	local cwd=$(getCwd)

	echo "$@" | sed "s|^${cwd}/||" | grep --extended-regexp --color "/?[^/]+$"
}
