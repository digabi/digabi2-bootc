#!/usr/bin/env bash

set -ouex pipefail

dnf5 install -y gdm gnome-kiosk-script-session ptyxis

flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install -y flathub io.github.ungoogled_software.ungoogled_chromium

useradd -m abitti
passwd -d abitti

cat > /tmp/L13 << EOF
[daemon]
#AutomaticLoginEnable=True
#AutomaticLogin=abitti

[security]

[xdmcp]

[chooser]

[debug]
Enable=false
EOF
install -D -m 0664 /tmp/L13 -T /etc/gdm/custom.conf

cat > /tmp/L29 << EOF
#!/usr/bin/env bash
flatpak run io.github.ungoogled_software.ungoogled_chromium --kiosk file:///var/home/abitti/Desktop/index.html --password-store=basic
EOF
install -D -m 0777 -o abitti /tmp/L29 -T /home/abitti/.local/bin/gnome-kiosk-script

install -D -m 0664 -o abitti /ctx/index.html -T /home/abitti/Desktop/index.html

cat > /tmp/L37 << EOF
[User]
Session=gnome-kiosk-script-wayland
SystemAccount=false
EOF
install -D -m 0664 /tmp/L37 -T /var/lib/AccountsService/users/abitti

cat > /tmp/L44 << EOF
[composefs]
enabled = yes
[sysroot]
readonly = true

[root]
transient = true
[etc]
transient = true
EOF
install -D -m 0664 /tmp/L44 -T /usr/lib/ostree/prepare-root.conf

cat > /tmp/L57 << EOF
KEYMAP=fi
XKBLAYOUT=fi
EOF
install -D -m 0664 /tmp/L57 -T /etc/vconsole.conf

cat > /tmp/L63 << EOF
polkit.addRule(function(action,subject) {
    if ( (action.id == "org.freedesktop.policykit.exec") &&
         (action.lookup("program") == "/usr/bin/bootc") &&
         (subject.isInGroup("wheel") ) ) {
      return polkit.Result.YES;
    }

    return polkit.Result.NOT_HANDLED;
  }
);
EOF
install -D -m 0644 /tmp/L63 -T /etc/polkit-1/rules.d/10-bootc-privileged.rules
