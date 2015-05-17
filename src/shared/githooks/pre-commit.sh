#!/usr/bin/env bash
set -e
set -u

if (( $(id -u) == 0 ));
then
   echo -E "np git hook: cannot be executed with root privileges." 1>&2
   exit 1
fi

externalExecutableExists() {
	local executable="$1"

	if [[ -z "$(which "$executable")" ]];
	then
		return 1
	else
		return 0
	fi
}

requireExternalExecutable() {
	local executable="$1"

	if externalExecutableExists "$executable";
	then
		return 0
	else
		echo -E "np git hook: '${executable}' was not found on the \$PATH." 1>&2
		exit 1
	fi
}

wasFileModifiedAndStaged() {
	file="$1"

	fileStatus="$(git status --porcelain :/ | sed -n "/M. ${file}/ p")"

	if [[ -z "$fileStatus" ]];
	then
		return 1
	else
		return 0
	fi
}

usageMdFile="USAGE.md"
manBaseDir="src/shared/man"
man1="${manBaseDir}/man1/np.1"

if wasFileModifiedAndStaged "$usageMdFile";
then
	echo -E "np git hook: the file '${usageMdFile}' was modified, converting it to man (roff) format in '${man1}'." 1>&2

	# Requiring "md2man-roff" seems a bit rough -- showing a warning for now to encourage git hook usage.
	# requireExternalExecutable "md2man-roff"

	if externalExecutableExists "md2man-roff";
	then
		md2man-roff "$usageMdFile" > "$man1";

		git add "$man1"
	else
		echo -E "np git hook: the file '${usageMdFile}' was modified, but 'md2man-roff'  wasn't found for the conversion. Skipping for now, but please let the np maintainers know." 1>&2
	fi
fi
