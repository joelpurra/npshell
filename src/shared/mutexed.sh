#!/usr/bin/env bash
set -e

if [[ -z "$thisInstanceIsAChild" ]] || (( thisInstanceIsAChild <= 0 ));
then
	exitIfAlreadyRunning "$configPidFile" "np"
	savePidButDeleteOnExit "np" "$$" "$configPidFile"
fi
