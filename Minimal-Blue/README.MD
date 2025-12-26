<i><h1>Minimal Blue</h1></i>
<img src="https://github.com/DanielPiliutsin/hyprland-dotfiles/blob/main/git/assests/display.gif"> 
<p>Non NVIDIA support is not guaranteed</p>
<h2>Desktop Packages:</h2>
<ul>
  <li>App Launcher ~> Rofi 🐶</li>
  <li>Terminal Emulator ~> Kitty 😺 (with Fish 🐟)</li>
  <li>Top-bar ~> Waybar ⏲</li>
  <li>Logout Screen ~> Wlogout 🖥️</li>
  <li>Lock Screen ~> Swaylock 🔒</li>
  <li>Wallpaper Daemon ~> SWWW 🌆</li>
  <li>File Manager ~> Thunar ⚡</li>
</ul>

<h2>Installation:</h2>
<h3>Install Hyprland:</h3>
<p><i>Note: If you are using wifi, you will need to follow a <a href="https://wiki.archlinux.org/title/Iwd">separate tutorial</a> before using archinstall.</i></p>
<p><i>WARNING: This step assumes you are booted into arch linux ISO with a single blank drive. Follow a separate tutorial when messing with the drive(s) selection if this is not applicable to you! I am not responsible for any damages caused by improper drive setup!</i></p>

```
archinstall
```
<p><b>follow the setup instructions and select the following: </b></p>
<ul>
 <li>Drive(s) - ...use a best-effort default partition layout | READ WARNING!</li> 
 <li>Profile - Desktop - Hyprland - Nvidia (Proprietary)</li>
 <li>Audio - Pipewire</li>
 <li>Network Configuration - Network Manager</li>
 <li>Optional Repositories - Multilib</li>
 <li>For the other options, they are up to you <b>(search them up if you dont know what they are for!)</b></li>
</ul>
<p>Then Click Install!</p>
<h3>Update the System:</h3>

```
sudo pacman -Syu
```

<h3>Install Paru:</h3>

```
sudo pacman -S --needed base-devel
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
```

<h3>Install the Essential Packages:</h3>

```
paru -Syu git python swww thunar kitty waybar rofi rofi-emoji fish udiskie swaylock wlogout playerctl nerd-fonts qt5ct neofetch btop firefox normcap hyprshot cava appimagelauncher gvfs android-udev usbmuxd gvfs-mtp libmtp blueberry-wayland ufraw-thumbnailer webp-pixbuf-loader hyprpicker wtype reflector imagemagick code dunst noto-fonts-emoji brightnessctl xdg-desktop-portal-hyprland
```
<h3>Enable the Services:</h3>

```
sudo systemctl enable --now reflector.timer
```
 
<h3>Copy the Configuration Files:</h3>

```
git clone --recursive https://github.com/DanielPiliutsin/hyprland-dotfiles
cd hyprland-dotfiles
cp -rTi .config $HOME/.config
cp -rTi .wallpapers $HOME/.wallpapers
```

<h3>Install and Update Plugins:</h3>

```
hyprpm add https://github.com/KZDKM/Hyprspace
hyprpm update
```

<h3>Reboot:</h3>

```
reboot
```
<!-- <h2>Other:</h2> 
<p>Coming Soon...</p> -->

<h2>Helpful Community Tutorials:</h2>
<p><a href="https://www.jasonross.dev/create-bootable-usb-arch-installation-from-windows/">Installing Arch Linux Onto USB</a></p>
<p><a href="https://www.techadvisor.com/article/728456/how-to-boot-from-usb.html">Booting From USB</a></p>
<p><a href="https://wiki.archlinux.org/title/Iwd">Connecting To Wifi</a></p>
