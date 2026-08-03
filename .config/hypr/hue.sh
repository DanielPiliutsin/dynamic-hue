#!/bin/bash

# Dynamic Hue Bash Utility #
############################

while test $# -gt 0; do
  case "$1" in
    -h|--help)
      echo "$package - attempt to capture frames"
      echo " "
      echo "$package [options] application [arguments]"
      echo " "
      echo "options:"
      echo "-h, --help                show brief help"
      echo "-r, --Reload       Reload The Random Customization"
      echo "-o, --output-dir=DIR      specify a directory to store output in"
      exit 0
      ;;
    --screenshot)
     shift
     hyprshot --freeze --mode region --output-folder "$HOME/Pictures/Screenshots/"
     paplay "$HOME/.config/hypr/assests/sounds/camera-shutter.ogg"
     shift
    ;;
    --screenshotfull)
     shift
     paplay "$HOME/.config/hypr/assests/sounds/camera-shutter.ogg"
     hyprshot -m output -m active --output-folder "$HOME/Pictures/Screenshots/"
     shift
     ;;
    -s)
      shift
      paplay "$HOME/.config/hypr/assests/sounds/startup.mp3"
      ~/.config/hypr/scripts/Dynamic_Weather.sh
      shift
      ;;
    -r)
    shift
    # Wallpaper for Theme
    paplay "$HOME/.config/hypr/assests/sounds/wallpaper_change.mp3"
    image_path=$(find ~/.wallpapers/General/ -type f | shuf -n1)

    # Customization
    awww img $image_path --transition-type wipe --transition-fps 120
    wal -i $image_path -n
    bash ~/.cache/wal/tclock.sh &

    # Cava Background For Second Monitor
    pkill -f "Kitty_Cava"
    # Kitty Requires home variable
    kitty +kitten panel --output-name DP-3 --edge=none --columns=1450px --lines=2580px --config "$HOME/.config/hypr/kittyconfigbg.conf" --margin-left=0 --margin-bottom=50 --name "Kitty_Cava" cava &

    # Tclock Background For Second Monitor
    kitty +kitten panel --output-name DP-3 --edge=center --config "$HOME/.config/hypr/kittyconfigbg.conf" --margin-left=0 --margin-bottom=1400 --name "Kitty_Clock" tclock clock -S -c "#8BA3B0" &
    sleep 3
    clear
    echo "done"
    shift
      ;;
    -o)
      shift
      if test $# -gt 0; then
        export OUTPUT=$1
      else
        echo "no output dir specified"
        exit 1
      fi
      shift
      ;;
    -n)
    shift
    WITH_WINDOW=false
    [[ "$1" == "--with-window" ]] && WITH_WINDOW=true

    # 1. Get current focused monitor and workspace ID
    current_info=$(hyprctl monitors -j | jq -r '.[] | select(.focused) | "\(.name) \(.activeWorkspace.id)"')
    read -r currMonitor currWorkspace <<< "$current_info"

    # 2. EDGE CASE: If we are in the "Void" (Workspace >= 990)
    if [ "$currWorkspace" -ge 990 ]; then
        target=$(hyprctl workspaces -j | jq -r 'map(select(.id < 990)) | sort_by(.id) | .[0].id')

        if [[ "$target" == "null" || -z "$target" ]]; then target=1; fi

        if $WITH_WINDOW; then
             hyprctl eval "hl.dispatch(hl.dsp.focus({ workspace = "$target" }))"
        else
            hyprctl eval "hl.dispatch(hl.dsp.focus({ workspace = "$target" }))"
        fi
        exit 0
    fi

    # Get all valid workspaces (< 990) for the current monitor, sorted ascending
    readarray -t workspaceIDs < <(hyprctl -j workspaces | jq -r --arg mon "$currMonitor" '.[] | select(.monitor == $mon and .id < 990) | .id' | sort -n)

    target_ws=""

    # Loop through to find the next strictly higher workspace ID
    for id in "${workspaceIDs[@]}"; do
        if (( id > currWorkspace )); then
            target_ws=$id
            break
        fi
    done

    if [[ -n "$target_ws" ]]; then
        # SCENARIO A: A higher valid workspace exists on this monitor
        if $WITH_WINDOW; then
            hyprctl eval "hl.dispatch(hl.dsp.focus({ workspace = '$target_ws' }))"
        else
            hyprctl eval "hl.dispatch(hl.dsp.focus({ workspace = '$target_ws' }))"
        fi
    else
        # SCENARIO B: CREATE NEW - We are at the end of the chain
        highestID=$(hyprctl -j workspaces | jq '.[].id | select(. < 990)' | sort -nr | head -n1)

        if [[ -z "$highestID" ]]; then
            nextID=1
        else
            nextID=$((highestID + 1))
        fi

        if $WITH_WINDOW; then
            hyprctl eval "hl.dispatch(hl.dsp.focus({ workspace = '$nextID' }))"
        else
            hyprctl eval "hl.dispatch(hl.dsp.focus({ workspace = '$nextID' }))"
        fi

        # Ensure the new workspace is pulled to the current monitor
        hyprctl dispatch moveworkspacetomonitor "$nextID" "$currMonitor"
    fi
    shift
       ;;
    -p)
    shift
    WITH_WINDOW=false
    [[ "$1" == "--with-window" ]] && WITH_WINDOW=true

    # 1. Get the current workspace ID
    current_ws=$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .activeWorkspace.id')

    # 2. Get a sorted list of ALL valid workspace IDs (strictly less than 990)
    mapfile -t valid_workspaces < <(hyprctl workspaces -j | jq -r 'map(select(.id < 990)) | sort_by(.id) | .[].id')

    # 3. Handle edge case: No valid workspaces exist
    if [ ${#valid_workspaces[@]} -eq 0 ]; then
        if $WITH_WINDOW; then
            hyprctl eval "hl.dispatch(hl.dsp.focus({ workspace = '1' }))"
        else
            hyprctl eval "hl.dispatch(hl.dsp.focus({ workspace = '1' }))"
        fi
        exit
    fi

    # 4. Find the index of the current workspace in our "safe list"
    current_index=-1
    for i in "${!valid_workspaces[@]}"; do
       if [[ "${valid_workspaces[$i]}" -eq "${current_ws}" ]]; then
           current_index=$i
           break
       fi
    done

    # 5. Calculate the Target
    if [[ $current_index -le 0 ]]; then
        # SCENARIO A: We are at the first workspace OR in the void (Index -1)
        target=${valid_workspaces[ ${#valid_workspaces[@]} - 1 ]}
    else
        # SCENARIO B: We are in the middle of the list
        target=${valid_workspaces[$current_index-1]}
    fi

    # 6. Dispatch
    if $WITH_WINDOW; then
        hyprctl eval "hl.dispatch(hl.dsp.focus({ workspace = "$target" }))"
    else
        hyprctl eval "hl.dispatch(hl.dsp.focus({ workspace = "$target" }))"
    fi

    shift
    ;;
    --output-dir*)
      export OUTPUT=`echo $1 | sed -e 's/^[^=]*=//g'`
      shift
      ;;
    *)
      break
      ;;
  esac
done
