#!/bin/bash

pkill -f 'MyKittenPanel' || kitty +kitten panel --edge=background --config "$HOME/.config/hypr/kittyconfigbg.conf" --name "MyKittenPanel" cava
