#!/bin/bash

# Check if idle inhibitor is enabled and trim whitespace
IDLE_INHIBITOR_ENABLED=$(qs -c caelestia ipc call idleInhibitor isEnabled | tr -d '[:space:]')

if [[ "${IDLE_INHIBITOR_ENABLED,,}" == "true" ]]; then
  qs -c caelestia ipc call idleInhibitor disable
  notify-send "󰛊  Stop locking computer when idle"
elif [[ "${IDLE_INHIBITOR_ENABLED,,}" == "false" ]]; then
  qs -c caelestia ipc call idleInhibitor enable
  notify-send "󰛊  Now locking computer when idle"
else
  notify-send "󰛊  Idle inhibitor state unknown: $IDLE_INHIBITOR_ENABLED"
fi
