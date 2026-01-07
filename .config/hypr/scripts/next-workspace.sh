#!/bin/bash

WITH_WINDOW=false
[[ "$1" == "--with-window" ]] && WITH_WINDOW=true

# Get current focused monitor and workspace ID
read -r currMonitor currWorkspace <<< $(hyprctl -j monitors | jq -r '.[] | select(.focused == true) | "\(.name) \(.activeWorkspace.id)"')

# Get all workspaces for the current monitor
readarray -t workspaceIDs < <(hyprctl -j workspaces | jq -r --arg mon "$currMonitor" '.[] | select(.monitor == $mon) | .id' | sort -nr)

highestOnMonitor="${workspaceIDs[0]}"

if (( highestOnMonitor > currWorkspace )); then
    if $WITH_WINDOW; then
        hyprctl dispatch movetoworkspace m+1
    else
        hyprctl dispatch workspace m+1
    fi
else
    # Find the absolute highest workspace ID across all monitors
    highestID=$(hyprctl -j workspaces | jq '.[].id' | sort -nr | head -n1)
    nextID=$((highestID + 1))

    if $WITH_WINDOW; then
        hyprctl dispatch movetoworkspace "$nextID"
    else
        hyprctl dispatch workspace "$nextID"
    fi

    hyprctl dispatch moveworkspacetomonitor "$nextID" "$currMonitor"
fi
