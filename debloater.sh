#!/bin/bash

# Script to uninstall LibreOffice and Brave Browser on Zorin OS
# Optionally upgrade the system with --upgrade flag

set -e

echo "🔧 Starting uninstallation process..."

# Remove LibreOffice
echo "📦 Removing LibreOffice..."
sudo apt remove --purge -y libreoffice*
sudo apt clean
sudo apt autoremove -y
rm -rf ~/.config/libreoffice

# Remove Brave Browser
echo "📦 Removing Brave Browser..."
sudo apt remove --purge -y brave-browser
sudo apt clean
sudo apt autoremove -y
sudo rm -f /etc/apt/sources.list.d/brave-browser-release.list
sudo rm -f /usr/share/keyrings/brave-browser-archive-keyring.gpg
rm -rf ~/.config/BraveSoftware
rm -rf ~/.cache/BraveSoftware

# Final clean-up
echo "🧹 Performing final cleanup..."
sudo apt autoremove --purge -y

# Optional: Update & Upgrade
if [[ "$1" == "--upgrade" ]]; then
  echo "🔄 Checking for updates and upgrading packages..."
  sudo apt update
  sudo apt upgrade -y
  sudo apt dist-upgrade -y
  echo "✅ System upgrade complete."
fi

echo "✅ Uninstallation complete."

