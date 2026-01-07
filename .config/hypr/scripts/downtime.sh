#!/bin/bash

# ==============================================================================
#               Downtime Enforcer - Script 1 (Main)
#
# This is the primary script. It checks the time and initiates shutdown.
# It also monitors 'watcher.sh' and restarts it if it's not running.
# ==============================================================================

# --- Configuration ---
SHUTDOWN_START_HOUR=22
SHUTDOWN_END_HOUR=6
# Define the path to the watcher script for easy reference.
# IMPORTANT: Make sure this path is correct!
WATCHER_SCRIPT_PATH="$HOME/.config/hypr/scripts/watcher.sh"

# --- Anti-Tampering Function ---
force_shutdown() {
    notify-send -u critical "🛑 Script 1 Interrupted" "Bypassing is not allowed. Shutting down now."
    systemctl poweroff
}

# --- Trap Signals ---
trap force_shutdown SIGINT SIGTERM SIGQUIT EXIT

# --- Main Loop ---
while true; do
    # --- Watcher Check ---
    # Check if the watcher script is currently running.
    # pgrep -f looks for the full command line, making it reliable.
    if ! pgrep -f "$WATCHER_SCRIPT_PATH" > /dev/null; then
        # If the watcher is not running, send a notification and restart it.
        notify-send -u normal "🛡️ Watcher Restarted" "The monitoring script was not found and has been restarted."
        # Relaunch the watcher script in the background.
        bash "$WATCHER_SCRIPT_PATH" &
    fi

    # --- Time Check Logic ---
    CURRENT_HOUR=$(date +%H)
    CURRENT_MINUTE=$(date +%M)

    # --- 5-Minute Shutdown Warning ---
    if [ "$CURRENT_HOUR" -eq $((SHUTDOWN_START_HOUR - 1)) ] && [ "$CURRENT_MINUTE" -eq 55 ]; then
        notify-send -u normal -t 300000 "🛌 Time for Bed!" "The computer will shut down in 5 minutes. Please save all your work."
    fi

    # --- Downtime Shutdown Logic ---
    if [ "$CURRENT_HOUR" -ge "$SHUTDOWN_START_HOUR" ] || [ "$CURRENT_HOUR" -lt "$SHUTDOWN_END_HOUR" ]; then
        notify-send -u critical "😴 Goodnight!" "Downtime has started. Shutting down now."
        sleep 3
        # Remove the trap for a clean shutdown.
        trap - SIGINT SIGTERM SIGQUIT EXIT
        # Kill the watcher script so it doesn't trigger a false positive.
        pkill -f "$WATCHER_SCRIPT_PATH"
        systemctl poweroff
        exit 0
    fi

    # Wait for 60 seconds before the next check.
    sleep 0.1
done
