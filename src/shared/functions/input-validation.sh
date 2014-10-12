#!/usr/bin/env bash
set -e

isValidStrictlyPositiveNumber() {
	declare -r str="$1"

	if [[ "$str" =~ ^[[:digit:]]+$ ]];
	then
		# Check if $1 has been interpreted to something else than it was before.
		# That is the strings "", "a", "abcdef" are all interpreted as zero.
		# Only afterwards can $n assumed to be zero, not "zero or any value that was not a number."
		# (Oh and the regex probably took care of it already, but wth.)
		declare -i -r n="$str"

		if [[ "$str" == "$n" ]] && (( n >= 0 ));
		then
			return 0
		else
			return 1
		fi
	else
		return 1
	fi
}

isValidNumsoundsOverride() {
	local override="$1"

	if [[ "$override" == "all" ]]; then
		return 0
	else
		return 1
	fi
}

isValidPlayOrder() {
	local order="$1"

	if [[ "$order" == "random" || "$order" == "in-order" ]]; then
		return 0
	else
		return 1
	fi
}
