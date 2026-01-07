#!/bin/bash

# --- CONFIGURATION ---
LAT="33.3062"
LON="-111.8413"
THRESHOLD=20

# UPDATED URL: We now request 'weather_code' as well
API_URL="https://api.open-meteo.com/v1/forecast?latitude=${LAT}&longitude=${LON}&daily=precipitation_probability_max,weather_code&timezone=America%2FPhoenix"

# --- COMMAND FUNCTIONS ---

function on_rain() {
    echo "🌧️  Rain likely ($1%). Executing rain command..."
    # Your Kitty Rain Command
    kitty +kitten panel --edge=none --columns=2660px --lines=1460px --config "$HOME/.config/hypr/kittyconfigbg.conf" --margin-right=10 --margin-top=10 --name "Kitty_Rain" rain
}

function on_snow_hail() {
    echo "❄️  Snow or Hail detected ($1%). Executing snow command..."
    # REPLACE WITH YOUR SNOW/HAIL COMMAND
    # Example:
    kitty +kitten panel --edge=none --columns=2660px --lines=1460px --config "$HOME/.config/hypr/kittyconfigbg.conf" --margin-right=10 --margin-top=10 --name "Kitty_Snow" $HOME/.config/hypr/scripts/Snow.sh
}

function on_clear() {
    echo "☀️  Clear skies ($1%). Executing clear command..."
    # COMMAND GOES HERE:
    # e.g., /path/to/clear_mode.sh
}
# ---------------------

# Dependency Check
if ! command -v jq &> /dev/null; then
    echo "Error: 'jq' is not installed."
    exit 1
fi

echo "Starting weather check service..."

while true; do
    # 1. CHECK FOR ACTIVE INTERNET CONNECTION
    if ! ping -c 1 -W 2 8.8.8.8 &> /dev/null; then
        echo "⚠️  No active internet connection. Waiting 5 seconds..."
        sleep 5
        continue
    fi

    # 2. QUERY THE API
    echo "🌐 Connection active. Querying API..."
    RESPONSE=$(curl -s --max-time 10 "$API_URL")
    CURL_EXIT=$?

    # 3. VALIDATE RESPONSE
    if [ $CURL_EXIT -ne 0 ] || [ -z "$RESPONSE" ] || ! echo "$RESPONSE" | jq empty &> /dev/null; then
        echo "❌ API Unreachable or Invalid Data. Timing out for 60 seconds..."
        sleep 60
        continue
    fi

    # 4. PARSE DATA
    CHANCE_TODAY=$(echo "$RESPONSE" | jq '.daily.precipitation_probability_max[0]')
    WEATHER_CODE=$(echo "$RESPONSE" | jq '.daily.weather_code[0]')

    # Double check for valid numbers
    if [[ "$CHANCE_TODAY" == "null" ]] || [[ "$WEATHER_CODE" == "null" ]]; then
        echo "❌ API returned unexpected format. Timing out for 60 seconds..."
        sleep 60
        continue
    fi

    # 5. EXECUTE LOGIC
    # First, check if precipitation chance is high enough
    if [[ "$CHANCE_TODAY" -gt "$THRESHOLD" ]]; then

        # If chance is high, check the WMO Weather Code to see WHAT is falling
        case $WEATHER_CODE in
            # Snow codes (71, 73, 75, 77, 85, 86) AND Hail codes (96, 99)
            71|73|75|77|85|86|96|99)
                on_snow_hail "$CHANCE_TODAY"
                ;;
            *)
                # All other codes (mostly rain or drizzle) go here
                on_rain "$CHANCE_TODAY"
                ;;
        esac

    else
        # Chance is below threshold (Clear/Cloudy but dry)
        on_clear "$CHANCE_TODAY"
    fi

    # Exit successfully
    exit 0
done
