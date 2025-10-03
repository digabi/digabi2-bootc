#!/usr/bin/env bash

set -ouex pipefail

dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
dnf install -y broadcom-wl

dnf install -y gdm gnome-kiosk-script-session chromium fedora-logos

cp -r /ctx/filesystem/* /
cp /ctx/watermark.png /usr/share/plymouth/themes/spinner/watermark.png

sed -i "s/{{BUILD_REVISION}}/$BUILD_REVISION/" /usr/share/digabi2-bootc/index.html
sed -i "s/{{BUILD_TIMESTAMP}}/$BUILD_TIMESTAMP/" /usr/share/digabi2-bootc/index.html
sed -i "s/{{BUILD_REVISION}}/$BUILD_REVISION/" /usr/lib/os-release

echo "digabi2-bootc $BUILD_REVISION" > /usr/lib/fedora-release

echo 'digabi::35225:35225:Digabi:/tmp/digabi:/usr/sbin/nologin' >> /usr/lib/passwd
echo 'digabi::35225:' >> /usr/lib/group

rm -f /home
