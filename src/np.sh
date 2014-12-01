#!/usr/bin/env bash
set -e

action=""

(( "$#" > 0 )) && { action="$1"; shift; }

[[ -z "$action" ]] && action="now"

executable="np-${action}.sh"

[[ -z $(which "$executable") ]] && { echo -E "np: '${action}' is not a action." 1>&2; exit 1; }

exec "$executable" "$@"