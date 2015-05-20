#!/usr/bin/env bash
set -e

externalExecutableExists() {
	local executable="$1"

	if builtin type "$executable" &>/dev/null;
	then
		return 0
	else
		return 1
	fi
}

action=""

(( "$#" > 0 )) && { action="$1"; shift; }

[[ -z "$action" ]] && action="now"

executable="np-${action}.sh"

if ! externalExecutableExists "$executable";
then
	executable="${BASH_SOURCE%/*}/${executable}"

	if ! externalExecutableExists "$executable";
	then
		echo -E "np: '${action}' is not a action." 1>&2; exit 1;
	fi
fi

exec "$executable" "$@"
