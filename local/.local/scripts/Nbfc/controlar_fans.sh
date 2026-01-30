#!/usr/bin/env bash

# Configure environment variables for the graphical session
export DISPLAY=:0
export XDG_RUNTIME_DIR=/run/user/$(id -u)
export DBUS_SESSION_BUS_ADDRESS="unix:path=$XDG_RUNTIME_DIR/bus"

Mode="Auto"
NO_NOTIFY=false

# Function to send notification
safe_notify() {
  if [ "$NO_NOTIFY" = false ] && [ -n "$DISPLAY" ] && [ -n "$DBUS_SESSION_BUS_ADDRESS" ] && command -v notify-send >/dev/null 2>&1; then
    notify-send "FanMode: $Mode" "Fan mode updated successfully!"
  fi
}

# Process arguments
for arg in "$@"; do
  case "$arg" in
  --no-notify)
    NO_NOTIFY=true
    ;;
  auto | Auto)
    Mode="Auto"
    ;;
  max | Max)
    Mode="Max"
    ;;
  *)
    Mode="Error"
    ;;
  esac
done

# Update fan mode
if [ "$Mode" == "Auto" ]; then
  nbfc set -a
  safe_notify
elif [ "$Mode" == "Max" ]; then
  nbfc set -s 100
  safe_notify
else
  notify-send "Error" "Failed to update fan mode"
fi
