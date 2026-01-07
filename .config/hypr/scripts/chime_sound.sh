#!/bin/bash

# Script to play an audio file with mpg123

# Check if an argument (file path) is provided
if [ -z "$1" ]; then
    echo "Usage: $0 chime.mp3"
    exit 1
fi

# Path to the audio file
AUDIO_FILE="$1"

# Play the audio file using mpg123
mpg123 "$AUDIO_FILE"

# Exit script
exit 0