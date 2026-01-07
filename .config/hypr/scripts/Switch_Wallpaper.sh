#!/bin/bash

paplay "$HOME/.config/hypr/assests/sounds/wallpaper_change.mp3"
image_path=$(find ~/.wallpapers/ -type f | shuf -n1)
swww img $image_path --transition-type wipe --transition-fps 120
wal -i $image_path -n ; hyprctl reload ; pkill -f "Kitty_Cava"
kitty +kitten panel --edge=none --columns=2660px --lines=1500px --config "$HOME/.config/hypr/kittyconfigbg.conf" --margin-left=0 --margin-bottom=50 --name "Kitty_Cava" cava
bash $HOME/.cache/wal/tclock.sh
gsettings set org.gnome.desktop.interface gtk-theme FlatColor && gsettings set org.gnome.desktop.interface gtk-theme pywall-dynamic