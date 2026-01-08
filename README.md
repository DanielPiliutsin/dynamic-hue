# Hyprland - <i>Dynamic Hue</i>
<p>a modern hyprland config focused on user productivity and elegance</p>
<img src="https://github.com/DanielPiliutsin/dynamic-hue/blob/main/git_assets/logo.jpeg?raw=true" width="300" height="300">

<h1>Preview: </h1>
<img src="https://github.com/DanielPiliutsin/dynamic-hue/blob/main/git_assets/preview.gif?raw=true">

<h1>Installation: </h1>
<h2>Manual ~ Reccomended</h2>
<p>1. Update System and install git </p>

```
sudo pacman -Syu git
```

<p>2. Install Paru </p>

```
sudo pacman -S --needed base-devel
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
```

<p>3. Install Packages</p>

```
paru -S gnome-font-viewer python swww thunar kitty waybar rofi rofi-emoji fish udiskie hyprlock wlogout playerctl nerd-fonts qt5ct neofetch btop zen-browser-bin normcap hyprshot cava appimagelauncher gvfs android-udev usbmuxd gvfs-mtp libmtp blueberry-wayland ufraw-thumbnailer webp-pixbuf-loader hyprpicker wtype reflector imagemagick zed dunst noto-fonts-emoji brightnessctl xdg-desktop-portal-hyprland python-pywal16 clock-tui ffmpeg-audio-thumbnailer nmgui-bin axel unzip ascii-rain-git misfortune
```

<p>4. Install Dotfiles</p>

```
git clone --recursive https://github.com/DanielPiliutsin/dynamic-hue
cd dynamic-hue/
cp -rTi .config $HOME/.config
cp -rTi .themes $HOME/.themes
cp -rTi .wallpapers $HOME/.wallpapers
```

<p>5. Install Fonts (in dynamic-hue directory) </p>

```
axel https://api.fontshare.com/v2/fonts/download/tanker
axel 'https://dl.dafont.com/dl/?f=wonderblend'
unzip tanker
unzip wonderblend.zip
sudo cp fonts/Outfit-Regular.otf /usr/share/fonts/
sudo cp fonts/Outfit-Thin.otf /usr/share/fonts/
sudo cp fonts/Pacifico-Regular.ttf /usr/share/fonts
sudo cp Tanker_Complete/Fonts/OTF/Tanker-Regular.otf /usr/share/fonts/
sudo cp wonderblend.regular.otf /usr/share/fonts/
```

<p>6. Run pywal to generate cache and link files</p>

```
wal -i "Lime/Assets/lime_preview.png"
chmod +x $HOME/.cache/wal/tclock.sh
ln $HOME/.cache/wal/cavaconfig $HOME/.config/cava/config
ln $HOME/.cache/wal/gtk.3.0.css $HOME/.themes/pywall-dynamic/gtk-3.0/gtk.css
ln $HOME/.cache/wal/gtk.css $HOME/.themes/pywall-dynamic/gtk-4.0/gtk.css
```

<p>7. Reboot!</p>

```
sudo reboot
```

<h2>Automatic - EXPERIMENTAL</h2>
<p>Install the <a href="https://github.com/DanielPiliutsin/dynamic-hue/raw/refs/heads/main/install.sh">script</a> and execute it in terminal.</p>
