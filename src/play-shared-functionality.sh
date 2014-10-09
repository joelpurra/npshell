#!/usr/bin/env bash
set -e

# The config is read after some debug calls are made, so might have to manually override $sharedDebug.
# Just uncomment the following line.
#sharedDebug=true

# Basic and execution configuration
readonly sharedDefaultConfigFolder="$HOME/.play"
sharedConfigFolder="$sharedDefaultConfigFolder"

readonly sharedDefaultDebug=false
sharedDebug="${sharedDebug:-sharedDefaultDebug}"

declare -a pidFilesCreatedByThisInstance
declare -a pidsCreatedByThisInstance
declare -a pidMessagesCreatedByThisInstance

{ trap 'onExit' EXIT; }

readonly sharedDefaultPidFile="${sharedConfigFolder}/.pidfile~"
sharedPidFile="$sharedDefaultPidFile"

readonly sharedDefaultDaemonPidFile="${sharedConfigFolder}/.daemonpidfile~"
sharedDaemonPidFile="$sharedDefaultDaemonPidFile"

readonly sharedDefaultAfplayerPidFile="${sharedConfigFolder}/.afplayerpidfile~"
sharedAfplayerPidFile="$sharedDefaultAfplayerPidFile"
