#!/bin/bash

# Usage check
if [[ "$EUID" -ne 0 ]]; then
  echo "Please run as root (e.g. sudo $0)"
  exit 1
fi

ROOT_PASSWORD="WPTAdmin321"
TARGET_USER="root"

# Check if user exists
if ! id "$TARGET_USER" &>/dev/null; then
  echo "User '$TARGET_USER' does not exist."
  exit 1
fi

echo "[*] Updating package list..."
apt update

echo "[*] Installing OpenSSH Server..."
apt install -y openssh-server

echo "[*] Enabling and starting SSH service..."
systemctl enable ssh
systemctl restart ssh

echo "[*] Setting root password..."
echo "root:$ROOT_PASSWORD" | chpasswd

echo "[*] Enabling root login in SSH config..."
sed -i 's/^#*PermitRootLogin .*/PermitRootLogin yes/' /etc/ssh/sshd_config
sed -i 's/^#*PasswordAuthentication .*/PasswordAuthentication yes/' /etc/ssh/sshd_config

echo "[*] Restarting SSH service to apply config..."
systemctl restart ssh

echo "[*] Granting passwordless sudo to user '$TARGET_USER'..."
echo "$TARGET_USER ALL=(ALL) NOPASSWD: ALL" > "/etc/sudoers.d/${TARGET_USER}_nopasswd"
chmod 440 "/etc/sudoers.d/${TARGET_USER}_nopasswd"

echo "[*] Setup complete."
echo "You can now SSH as root with the provided password."
echo "User '$TARGET_USER' can use sudo without password."

