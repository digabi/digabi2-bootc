#!/usr/bin/env bash

set -ouex pipefail

dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# Install core packages
dnf install -y gdm gnome-kiosk-script-session chromium fedora-logos

# Install user management tools (required for ISO building)
dnf install -y shadow-utils passwd

# Install general wireless firmware (covers most hardware)
dnf install -y linux-firmware || true

# Try to install broadcom-wl if available (only needed for specific Broadcom wireless cards)
# This package is often unavailable on bootc images due to kernel module dependencies
dnf install -y broadcom-wl || echo "WARNING: broadcom-wl not available, skipping"

cp -r /ctx/filesystem/* /
cp /ctx/watermark.png /usr/share/plymouth/themes/spinner/watermark.png

sed -i "s/{{BUILD_REVISION}}/$BUILD_REVISION/" /usr/share/digabi2-bootc/index.html
sed -i "s/{{BUILD_TIMESTAMP}}/$BUILD_TIMESTAMP/" /usr/share/digabi2-bootc/index.html

# Generate a version string with date and git SHA
BUILD_DATE=$(date +%Y%m%d)
BUILD_VERSION="1.${BUILD_DATE}.0-git${BUILD_REVISION:0:7}"

# Update os-release PRETTY_NAME with version info
sed -i "s/{{BUILD_REVISION}}/$BUILD_VERSION/" /usr/lib/os-release

# Update fedora-release
echo "Digabi2 Bootc release $BUILD_VERSION" > /usr/lib/fedora-release

echo 'digabi::35225:35225:Digabi:/tmp/digabi:/usr/sbin/nologin' >> /usr/lib/passwd
echo 'digabi::35225:' >> /usr/lib/group

rm -f /home
