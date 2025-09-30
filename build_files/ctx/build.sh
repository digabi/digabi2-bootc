#!/usr/bin/env bash

set -ouex pipefail

dnf5 install -y gdm gnome-kiosk-script-session chromium fedora-logos

useradd -m digabi
passwd -d digabi

cp -r /ctx/filesystem/* /
cp /ctx/watermark.png /usr/share/plymouth/themes/spinner/watermark.png

sed -i "s/{{BUILD_REVISION}}/$BUILD_REVISION/" /usr/share/digabi2-bootc/index.html
sed -i "s/{{BUILD_TIMESTAMP}}/$BUILD_TIMESTAMP/" /usr/share/digabi2-bootc/index.html
sed -i "s/{{BUILD_REVISION}}/$BUILD_REVISION/" /usr/lib/os-release

echo "digabi2-bootc $BUILD_REVISION" > /usr/lib/fedora-release
