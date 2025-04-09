#!/bin/bash

set -e

echo "===> Atualizando sistema..."
sudo pacman -Syu --noconfirm

echo "===> Instalando pacotes base e yay (AUR helper)..."
sudo pacman -S --needed git base-devel --noconfirm
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --noconfirm
cd ..
rm -rf yay

echo "===> Instalando Hyprland e componentes essenciais..."
sudo pacman -S hyprland xorg-xwayland xdg-desktop-portal-hyprland xdg-utils --noconfirm

echo "===> Instalando terminal e shell padrão..."
sudo pacman -S foot bash --noconfirm

echo "===> Instalando barra, menu, notificações..."
sudo pacman -S waybar wofi mako --noconfirm

echo "===> Instalando áudio (Pipewire)..."
sudo pacman -S pipewire pipewire-audio wireplumber pavucontrol --noconfirm

echo "===> Instalando gerenciador de rede..."
sudo pacman -S networkmanager network-manager-applet --noconfirm
sudo systemctl enable NetworkManager
sudo systemctl start NetworkManager

echo "===> Instalando tema de cursor e fontes nerd fonts..."
sudo pacman -S xcursor-breeze ttf-jetbrains-mono-nerd ttf-nerd-fonts-symbols --noconfirm

echo "===> Instalando gerenciador de arquivos..."
sudo pacman -S thunar gvfs udiskie --noconfirm

echo "===> Instalando captura de tela..."
sudo pacman -S grim slurp --noconfirm

echo "===> Instalando utilitários extras..."
sudo pacman -S unzip zip wget curl neofetch --noconfirm

echo "===> Instalando VS Code (opcional)..."
yay -S visual-studio-code-bin --noconfirm

echo "===> Criando config padrão para iniciar Hyprland..."
echo 'exec Hyprland' > ~/.xinitrc

echo "===> Aplicando configurações básicas..."
mkdir -p ~/.config/hypr ~/.config/waybar ~/.config/wofi ~/.config/foot

# Hyprland config
cat <<EOF > ~/.config/hypr/hyprland.conf
exec-once = waybar &
exec-once = mako &
exec-once = nm-applet &
exec-once = udiskie -t &
exec-once = swww init && swww img ~/wallpaper.jpg

input {
    kb_layout = br
    follow_mouse = 1
    touchpad {
        natural_scroll = true
    }
}

general {
    gaps_in = 5
    gaps_out = 10
    border_size = 2
    col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
    col.inactive_border = rgba(595959aa)
}

decoration {
    rounding = 10
    blur {
        enabled = true
        size = 8
        passes = 2
    }
}
EOF

# Waybar config (mínimo)
cat <<EOF > ~/.config/waybar/config.jsonc
{
  "layer": "top",
  "position": "top",
  "modules-left": ["hyprland/workspaces"],
  "modules-center": ["clock"],
  "modules-right": ["pulseaudio", "network", "battery"],
  "clock": {
    "format": "%a %d/%m %H:%M"
  },
  "pulseaudio": {
    "format": "♫ {volume}%"
  }
}
EOF

# Wofi config (mínimo)
mkdir -p ~/.config/wofi
cat <<EOF > ~/.config/wofi/style.css
window {
  margin: 5px;
  border: 2px solid #33ccff;
  background-color: #1e1e2e;
  color: #cdd6f4;
}

#entry:selected {
  background-color: #89b4fa;
  color: #1e1e2e;
}
EOF

# Foot config
cat <<EOF > ~/.config/foot/foot.ini
[main]
font=JetBrainsMono Nerd Font:size=11
shell=bash

[colors]
foreground=dadada
background=1e1e2e
EOF

echo "===> Instalação e configuração concluídas! Reinicie e rode 'startx' para iniciar o Hyprland."
