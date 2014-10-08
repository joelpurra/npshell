#!/usr/bin/env bash
set -e

# Basic and execution configuration
sharedDefaultConfigFolder="$HOME/.play"
sharedConfigFolder="$sharedDefaultConfigFolder"

sharedDefaultPidFile="${sharedConfigFolder}/.pidfile~"
sharedPidFile="$sharedDefaultPidFile"

sharedDefaultDaemonPidFile="${sharedConfigFolder}/.daemonpidfile~"
sharedDaemonPidFile="$sharedDefaultDaemonPidFile"

sharedDefaultAfplayerPidFile="${sharedConfigFolder}/.afplayerpidfile~"
sharedAfplayerPidFile="$sharedDefaultAfplayerPidFile"
