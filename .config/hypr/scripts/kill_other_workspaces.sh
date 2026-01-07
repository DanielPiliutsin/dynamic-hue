#!/bin/bash

# Get current workspace
current_ws=$(hyprctl activeworkspace -j | jq '.id')

# Get all windows (clients)
hyprctl clients -j | jq -c '.[]' | while read -r client; do
    ws=$(echo "$client" | jq '.workspace.id')
    pid=$(echo "$client" | jq '.pid')
    
    # Kill if not on current workspace
    if [ "$ws" != "$current_ws" ]; then
        kill -9 "$pid"
    fi
done
