#!/bin/bash

# Enable the multilib repository
cat << EOM >> /etc/pacman.conf
[multilib]
Include = /etc/pacman.d/mirrorlist
[jp7-arch]
SigLevel = Never
Server = https://r.zhullyb.top/https://github.com/JPratama7/arch-builder/releases/download/latest/
Server = https://github.com/JPratama7/arch-builder/releases/download/latest/
Server = https://git.aya1.top/JPratama7/arch-builder/releases/download/latest/
Server = https://hub.fastgit.xyz/JPratama7/arch-builder/releases/download/latest/
EOM
pacman -Syu --noconfirm --needed yay gtk2 gtk3 gtk4

git clone "https://aur.archlinux.org/$1.git"

echo "Creating .SRCINFO"
makepkg --printsrcinfo > .SRCINFO
mapfile -t PKGDEPS < \
	<(sed -n -e 's/^[[:space:]]*\(make\)\?depends\(_x86_64\)\? = \([[:alnum:][:punct:]]*\)[[:space:]]*$/\3/p' .SRCINFO)
yay -Syyu --noconfirm ${PKGDEPS[@]}
cd "$1"
makepkg --syncdeps --noconfirm
