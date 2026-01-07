#!/bin/bash

# Custom welcome message
kitty --hold sh -c 'echo "                          
                     \       /
                        - - 
                  --  /     \  --
-----------------------------------------------------
Welcome to Hyprland!

Dictionary:
 SUPER = Windows Key/Command key
 + = Hold button down before the plus and click the button after it

Key Binds:
 SUPER + Left = Takes you to the left workspace
 SUPER + right = Takes you to the right workspace
 SUPER + SPACE = Opens/Closes app launcher (rofi)
 SUPER + BACKSPACE = Closes window under mouse
 SUPER + M = Logs you out
 SUPER + SHIFT + NUMBER = Sends Window under mouse to NUMBER workspace

Other Fetures To Know:
- Scrolling over volume indicator adjusts it
- Clicking volume indicator toggles mute
- Thunar is the file manager
- Firefox is the browser
- Ghost icon opens app launcher

Please dont mess with anything you dont know...
Please dont break or hack anything on purpose...

Enjoy!" ; exec bash'
