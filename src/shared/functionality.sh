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

readonly configDefaultExternalPlayerPidFile="${configConfigFolder}/.externalplayerpidfile~"
configExternalPlayerPidFile="$configDefaultExternalPlayerPidFile"

readonly configDefaultNotifyPidFile="${configConfigFolder}/.notifypidfile~"
configNotifyPidFile="$configDefaultNotifyPidFile"


# File configuration defaults.
configDefaultQueueFile="${configConfigFolder}/queue.pls"
configQueueFile="$configDefaultQueueFile"

configDefaultHistoryFile="${configConfigFolder}/history.pls"
configHistoryFile="$configDefaultHistoryFile"

configDefaultModeFile="${configConfigFolder}/.mode"
configModeFile="$configDefaultModeFile"

configDefaultPlayingFile="${configConfigFolder}/.playing"
configPlayingFile="$configDefaultPlayingFile"

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

configDefaultFollowSymlinks="false"
configFollowSymlinks="$configDefaultFollowSymlinks"


# Allow $configConfigFile to override above configuration.
readConfig
