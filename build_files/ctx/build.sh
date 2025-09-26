#!/usr/bin/env bash

set -ouex pipefail

dnf5 install -y gdm gnome-kiosk-script-session chromium

useradd -m digabi
passwd -d digabi

cp -r /ctx/filesystem/* /

sed -i "s/{{BUILD_REVISION}}/$BUILD_REVISION/" /usr/share/digabi2-bootc/index.html
sed -i "s/{{BUILD_TIMESTAMP}}/$BUILD_TIMESTAMP/" /usr/share/digabi2-bootc/index.html
