#!/usr/bin/env bash
set -e

exitIfAlreadyRunningOrCleanup "$configPidFile" "np"
savePidButDeleteOnExit "np" "$$" "$configPidFile"
