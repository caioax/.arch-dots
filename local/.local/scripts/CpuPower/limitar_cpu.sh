#!/usr/bin/env bash

# Auto-detect graphical environment
export DISPLAY=:0
export XDG_RUNTIME_DIR="/run/user/$(id -u)"

# Capture DBUS from current session (KDE, GNOME, etc.)
if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
  DBUS_SESSION_BUS_ADDRESS=$(grep -z DBUS_SESSION_BUS_ADDRESS /proc/$(pgrep -u $USER -x plasmashell || pgrep -u $USER -x gnome-shell)/environ | cut -d= -f2-)
  export DBUS_SESSION_BUS_ADDRESS
fi

# Pre-defined frequencies (adjust for your processor)
FREQ_LOW="1.0GHz"
FREQ_BASE="2.3GHz"
FREQ_HIGH="3.0GHz"
FREQ_ULTRA="3.9GHz"
FREQ_MAX="4.6GHz" # special value used by cpupower for "no limit"

# Default values
FREQ_TARGET="$FREQ_BASE"
PROFILE_NAME="Base"
NO_NOTIFY=false

show_help() {
  echo "Usage: limitarcpu [Profile|Value] [--no-notify]"
  echo
  echo "Available profiles:"
  echo "  Low     → $FREQ_LOW"
  echo "  Base    → $FREQ_BASE"
  echo "  High    → $FREQ_HIGH"
  echo "  Ultra   → $FREQ_ULTRA"
  echo "  Max     → Maximum supported frequency (no limit)"
  echo
  echo "You can also pass a manual value, e.g.: 2.5GHz"
  echo
  echo "Options:"
  echo "  --no-notify   Run without showing notification"
  echo "  -h, --help    Show this help"
  exit 0
}

# Process arguments
for arg in "$@"; do
  case "$arg" in
  --no-notify)
    NO_NOTIFY=true
    ;;
  -h | --help)
    show_help
    ;;
  Low | low)
    FREQ_TARGET="$FREQ_LOW"
    PROFILE_NAME="Low"
    ;;
  Base | base)
    FREQ_TARGET="$FREQ_BASE"
    PROFILE_NAME="Base"
    ;;
  High | high)
    FREQ_TARGET="$FREQ_HIGH"
    PROFILE_NAME="High"
    ;;
  Ultra | ultra)
    FREQ_TARGET="$FREQ_ULTRA"
    PROFILE_NAME="Ultra"
    ;;
  Max | max)
    FREQ_TARGET="$FREQ_MAX"
    PROFILE_NAME="Max"
    ;;
  *)
    # If not a keyword, assume manual value
    FREQ_TARGET="$arg"
    PROFILE_NAME="Custom"
    ;;
  esac
done

# Function to send notification
function safe_notify {
  if [ "$NO_NOTIFY" = false ] && [ -n "$DISPLAY" ] && [ -n "$DBUS_SESSION_BUS_ADDRESS" ] && command -v notify-send >/dev/null 2>&1; then
    notify-send "FreqCPU: $PROFILE_NAME" "Max frequency set to $FREQ_TARGET"
  fi
}

# Try to set the new frequency
if sudo -n /usr/bin/cpupower frequency-set -u "$FREQ_TARGET"; then

  safe_notify
else
  notify-send "FreqCPU: Error" "Failed to set frequency to $FREQ_TARGET"
fi
