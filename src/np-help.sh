#!/usr/bin/env bash
set -e

action=""

(( "$#" > 0 )) && { action="$1"; shift; }

[[ -z "$action" ]] && action="help"

helpfile="${BASH_SOURCE%/*}/help/np-${action}.txt"

if [[ -f $helpfile ]];
then
	cat $helpfile
else
	echo -E "np: '${action}' is not a action." 1>&2
	exit 1
fi

