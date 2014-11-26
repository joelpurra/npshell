#!/usr/bin/env bash
set -e

source "${BASH_SOURCE%/*}/shared/functions.sh"
source "${BASH_SOURCE%/*}/shared/functionality.sh"
source "${BASH_SOURCE%/*}/shared/mutexed.sh"

recursive=false
clean=false
force=false

declare -i argumentsCount=0

while (( argumentsCount != "$#" ));
do
	argumentsCount="$#"

	if [[ "$1" == "--recursive" ]];
	then
		recursive=true
		shift
	fi

	if [[ "$1" == "--clean" ]];
	then
		clean=true
		shift
	fi

	if [[ "$1" == "--force" ]];
	then
		force=true
		shift
	fi
done

if [[ "$force" == true && "$recursive" == true ]];
then
	die "can't --force and --recursive"
fi

if [[ "$force" == true && "$clean" == true ]];
then
	die "can't --force and --clean"
fi

if [[ "$clean" == true ]];
then
	if [[ "$recursive" == true ]];
	then
		deleteSoundCacheRecursively
	else
		deleteSoundCache
	fi
else
	if soundCacheExists && [[ "$force" != true ]];
	then
		exit 0
	else
		generateSoundCache
	fi
fi
