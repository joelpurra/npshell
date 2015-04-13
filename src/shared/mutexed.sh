#!/usr/bin/env bash
set -e

exitIfAlreadyRunning "$configPidFile" "np"
savePidButDeleteOnExit "np" "$$" "$configPidFile"
