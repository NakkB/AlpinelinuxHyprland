#!/bin/sh
# Script cài Hyprland trên Alpine Linux (dựa trên ronardnx/hyprland_alpinelinux)

set -e

USER_NAME=$(whoami)

echo "[*] Cập nhật hệ thống..."
doas apk update
doas apk upgrade

echo "[*] Cài đặt các gói cần thiết..."
doas apk add \
  hyprland waybar rofi-wayland nwg-look kitty kitty-terminfo \
  mesa-dri-gallium mesa-egl \
  brightnessctl pulseaudio mako grim wl-clipboard slurp librsvg swaybg \
  mate-polkit fish seatd consolekit2 starship lf dbus elogind polkit \
  git

echo "[*] Kích hoạt dịch vụ cần thiết..."
doas rc-update add seatd
doas rc-update add elogind
doas rc-update add dbus
doas rc-update add polkit
doas rc-service seatd start
doas rc-service elogind start
doas rc-service dbus start
doas rc-service polkit start

echo "[*] Clone repo cấu hình Hyprland..."
git clone https://github.com/ronardnx/hyprland_alpinelinux /tmp/hyprland_alpine
cd /tmp/hyprland_alpine
rm -rf .git

echo "[*] Copy cấu hình vào home..."
mkdir -p ~/.config ~/.local
cp -r .config/* ~/.config/
cp -r .local/* ~/.local/

echo "[*] Thêm user vào group seat, video..."
doas adduser "$USER_NAME" seat || true
doas adduser "$USER_NAME" video || true

echo "[*] Đổi shell mặc định sang fish..."
doas chsh -s /usr/bin/fish "$USER_NAME"

echo
echo "============================================="
echo "Hoàn tất! Hãy reboot máy rồi đăng nhập TTY,"
echo "sau đó gõ: startx"
echo "(script đã cấu hình sẵn để chạy dbus-run-session Hyprland)"
echo "============================================="
