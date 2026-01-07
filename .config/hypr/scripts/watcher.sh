#!/bin/bash

# ==============================================================================
#               Downtime Enforcer - Script 2 (Watcher)
#
# This script's only job is to monitor 'downtime.sh'.
# If 'downtime.sh' is terminated for any reason, this script
# will immediately trigger a system shutdown.
# ==============================================================================

# Define the path to the main script for easy reference.
# IMPORTANT: Make sure this path is correct!
MAIN_SCRIPT_PATH="$HOME/.config/hypr/scripts/downtime.sh"

# --- Anti-Tampering Function ---
force_shutdown() {
    notify-send -u critical "🛑 Script 2 Interrupted" "Bypassing is not allowed. Shutting down now."
    systemctl poweroff
}

# --- Trap Signals ---
# If this script is terminated, it also triggers a shutdown.
trap force_shutdown SIGINT SIGTERM SIGQUIT EXIT

# --- Monitoring Loop ---
while true; do
    # --- Main Script Check ---
    # Check if the main script is currently running.
    if ! pgrep -f "$MAIN_SCRIPT_PATH" > /dev/null; then
        # If the main script is not running, it means it was likely killed.
        # Trigger an immediate shutdown.
        notify-send -u critical "🚨 Main Script Missing!" "The main downtime script is not running. Shutting down as a precaution."
        sleep 3
        # Remove the trap for a clean shutdown.
        trap - SIGINT SIGTERM SIGQUIT EXIT
        systemctl poweroff
        exit 0
    fi

    # Check every 5 seconds. A shorter interval makes it harder to bypass.
    sleep 0.1
done
