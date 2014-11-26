#!/usr/bin/env bash
set -e

[[ -z "$thisInstanceIsAChild" ]] || (( thisInstanceIsAChild <= 0 )) && exitIfAlreadyRunning "$configPidFile" "play"
[[ -z "$thisInstanceIsAChild" ]] || (( thisInstanceIsAChild <= 0 )) && savePidButDeleteOnExit "play" "$$" "$configPidFile"

# Normal configuration
configDefaultConfigFile="${configConfigFolder}/config.sh"
configConfigFile="$configDefaultConfigFile"

configDefaultQueueFile="${configConfigFolder}/queue.pls"
configQueueFile="$configDefaultQueueFile"

configDefaultHistoryFile="${configConfigFolder}/history.pls"
configHistoryFile="$configDefaultHistoryFile"

configDefaultUseCache=true
configUseCache="$configDefaultUseCache"

configDefaultNumsounds=10
configNumsounds="$configDefaultNumsounds"

configDefaultOrder="random"
configOrder="$configDefaultOrder"

configCacheFileName=".play.cache~"

ensureFoldersAndFilesExist

readConfig
