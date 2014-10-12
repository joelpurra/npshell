#!/usr/bin/env bash
set -e

[[ -z "$thisInstanceIsAChild" ]] || (( thisInstanceIsAChild <= 0 )) && exitIfAlreadyRunning "$sharedPidFile" "play"
[[ -z "$thisInstanceIsAChild" ]] || (( thisInstanceIsAChild <= 0 )) && savePidButDeleteOnExit "play" "$$" "$sharedPidFile"

# Normal configuration
sharedDefaultConfigFile="${sharedConfigFolder}/config.sh"
sharedConfigFile="$sharedDefaultConfigFile"

sharedDefaultQueueFile="${sharedConfigFolder}/queue.pls"
sharedQueueFile="$sharedDefaultQueueFile"

sharedDefaultHistoryFile="${sharedConfigFolder}/history.pls"
sharedHistoryFile="$sharedDefaultHistoryFile"

sharedDefaultUseCache=true
sharedUseCache="$sharedDefaultUseCache"

sharedDefaultNumsounds=10
sharedNumsounds="$sharedDefaultNumsounds"

sharedDefaultOrder="random"
sharedOrder="$sharedDefaultOrder"

sharedCacheFile=".play.cache~"

sharedCwd=$(getCdw)

ensureFoldersAndFilesExist

readConfig
