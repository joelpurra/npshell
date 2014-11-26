#!/usr/bin/env bash
set -e

[[ -z "$thisInstanceIsAChild" ]] || (( thisInstanceIsAChild <= 0 )) && exitIfAlreadyRunning "$configPidFile" "np"
[[ -z "$thisInstanceIsAChild" ]] || (( thisInstanceIsAChild <= 0 )) && savePidButDeleteOnExit "np" "$$" "$configPidFile"

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

configCacheFileName=".np.cache~"

ensureFoldersAndFilesExist

readConfig
