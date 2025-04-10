#!/bin/bash

# === CONFIGURAÇÕES DO SISTEMA D ===
SSD="/dev/sda"
efi_part="${SSD}1"
root_part="${SSD}2"
username="danielD"
hostname="archhyprD"

# === PARTIÇÕES D ===
echo -e "\n>>> Certifique-se de ter criado: D"
echo -e " - ${efi_part} como EFI (512MB FAT32) D"
echo -e " - ${root_part} como Linux Filesystem (~149GB) D"
read -p "Pressione ENTER para continuar após particionar com 'cfdisk ${SSD}'... D"

# === FORMATANDO AS PARTIÇÕES D ===
mkfs.fat -F32 $efi_part
mkfs.ext4 $root_part

# === MONTAGEM D ===
mount $root_part /mnt
mkdir -p /mnt/boot
mount $efi_part /mnt/boot

# === INSTALANDO PACOTES BASE D ===
pacstrap -K /mnt base linux linux-firmware git nano sudo networkmanager grub efibootmgr

# === GERAÇÃO DO FSTAB D ===
genfstab -U /mnt >> /mnt/etc/fstab

# === CONFIGURAÇÕES DO SISTEMA D ===
arch-chroot /mnt /bin/bash <<EOF

ln -sf /usr/share/zoneinfo/America/Recife /etc/localtime
hwclock --systohc

echo "pt_BR.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=pt_BR.UTF-8" > /etc/locale.conf

echo "$hostname" > /etc/hostname  # hostnameD

echo "127.0.0.1   localhost" >> /etc/hosts
echo "::1         localhost" >> /etc/hosts
echo "127.0.1.1   $hostname.localdomain $hostname" >> /etc/hosts  # hostsD

# === CRIAÇÃO DO USUÁRIO D ===
useradd -m -G wheel $username
echo -e "danielD\ndanielD" | passwd $username

# === LIBERA USO DE SUDO PARA WHEEL D ===
sed -i 's/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers

# === HABILITA INTERNET D ===
systemctl enable NetworkManager

# === TECLADO ABNT2 D ===
echo "KEYMAP=br-abnt2" > /etc/vconsole.conf

# === INSTALAÇÃO DO GRUB D ===
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

EOF

# === FINAL D ===
echo -e "\n>>> Instalação concluída! D"
echo -e "Reinicie, entre com o usuário '$username' e rode: D"
echo -e "git clone https://github.com/daniel-farias1712/Instala-o-hyprland.git"
echo -e "cd Instala-o-hyprland && chmod +x install.sh && ./install.sh"
