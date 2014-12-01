#!/usr/bin/env bash
set -e

# Debugging configuration defaults.
readonly configDefaultDebug=false
configDebug="$configDefaultDebug"


# Fundamental configuration defaults.
readonly configDefaultConfigFolder="${HOME}/.np"
configConfigFolder="$configDefaultConfigFolder"

configDefaultConfigFile="${configConfigFolder}/config.sh"
configConfigFile="$configDefaultConfigFile"

ensureConfigFoldersAndFilesExist


# Keep track of lock/pid files.
declare -a pidFilesCreatedByThisInstance
declare -a pidsCreatedByThisInstance
declare -a pidMessagesCreatedByThisInstance

{ trap 'onExit' EXIT; }


# Lock/pid files defaults.
readonly configDefaultPidFile="${configConfigFolder}/.pidfile~"
configPidFile="$configDefaultPidFile"

readonly configDefaultDaemonPidFile="${configConfigFolder}/.daemonpidfile~"
configDaemonPidFile="$configDefaultDaemonPidFile"

readonly configDefaultPlayerPidFile="${configConfigFolder}/.playerpidfile~"
configPlayerPidFile="$configDefaultPlayerPidFile"

readonly configDefaultExternalPlayerPidFile="${configConfigFolder}/.externalplayerpidfile~"
configExternalPlayerPidFile="$configDefaultExternalPlayerPidFile"


# File configuration defaults.
configDefaultQueueFile="${configConfigFolder}/queue.pls"
configQueueFile="$configDefaultQueueFile"

configDefaultHistoryFile="${configConfigFolder}/history.pls"
configHistoryFile="$configDefaultHistoryFile"

ensureOtherFoldersAndFilesExist


# Advanced configuration defaults.
readonly configDefaultCacheFileName=".np.cache~"
configCacheFileName="$configDefaultCacheFileName"


# Normal configuration defaults.
configDefaultUseCache=true
configUseCache="$configDefaultUseCache"

configDefaultNumsounds=10
configNumsounds="$configDefaultNumsounds"

configDefaultOrder="shuffle"
configOrder="$configDefaultOrder"


# Allow $configConfigFile to override above configuration.
readConfig