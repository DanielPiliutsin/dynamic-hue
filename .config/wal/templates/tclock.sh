#!/bin/bash

pkill -f "Kitty_Clock"
kitty +kitten panel --edge=center --config "$HOME/.config/hypr/kittyconfigbg.conf" --margin-left=0 --margin-bottom=1000 --name "Kitty_Clock" tclock -c "{color14}"
