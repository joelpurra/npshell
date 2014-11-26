#!/usr/bin/env bash
set -e

# The config is read after some debug calls are made, so might have to manually override $configDebug.
# Just uncomment the following line.
#configDebug=true

# Basic and execution configuration
readonly configDefaultConfigFolder="$HOME/.play"
configConfigFolder="$configDefaultConfigFolder"

readonly configDefaultDebug=false
configDebug="${configDebug:-configDefaultDebug}"

declare -a pidFilesCreatedByThisInstance
declare -a pidsCreatedByThisInstance
declare -a pidMessagesCreatedByThisInstance

{ trap 'onExit' EXIT; }

readonly configDefaultPidFile="${configConfigFolder}/.pidfile~"
configPidFile="$configDefaultPidFile"

readonly configDefaultDaemonPidFile="${configConfigFolder}/.daemonpidfile~"
configDaemonPidFile="$configDefaultDaemonPidFile"

readonly configDefaultPlayerPidFile="${configConfigFolder}/.playerpidfile~"
configPlayerPidFile="$configDefaultPlayerPidFile"

readonly configDefaultExternalPlayerPidFile="${configConfigFolder}/.externalplayerpidfile~"
configExternalPlayerPidFile="$configDefaultExternalPlayerPidFile"
