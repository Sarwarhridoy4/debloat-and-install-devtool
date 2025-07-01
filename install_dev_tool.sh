#!/usr/bin/env bash
# install_dev_tools.sh
# Cleans any existing installations of Git, VS Code, Node.js (via fnm), and Postman
# then installs fresh copies on Debian‑based Linux.
# Usage: sudo bash install_dev_tools.sh

set -euo pipefail

echo "=== Development Toolkit Reinstaller ==="

###############################################################################
# 0. Require root                                                            #
###############################################################################
if [[ "$EUID" -ne 0 ]]; then
  echo "[ERROR] Please run this script with sudo or as root." >&2
  exit 1
fi

###############################################################################
# 1. Cleanup any previous installations & conflicting repos                  #
###############################################################################
cleanup() {
  echo "[INFO] Cleaning up existing packages & conflicting repositories …"

  # ── VS Code & Microsoft repo ────────────────────────────────────────────
  apt-get -y purge code || true
  # Remove any .list referencing packages.microsoft.com to avoid keyring clashes
  find /etc/apt/sources.list.d -type f -name "*.list" -exec grep -l "packages.microsoft.com" {} + | xargs -r rm -f
  # Strip possible entries from main sources.list
  sed -i.bak '/packages.microsoft.com/d' /etc/apt/sources.list
  # Remove old keyrings
  rm -f /usr/share/keyrings/{microsoft.gpg,packages.microsoft.gpg}

  # ── Git ────────────────────────────────────────────────────────────────
  apt-get -y purge git || true

  # ── Postman snap ───────────────────────────────────────────────────────
  if command -v snap >/dev/null 2>&1 && snap list | awk '{print $1}' | grep -q '^postman$'; then
    echo "  • Removing Postman snap …"
    snap remove postman
  fi

  # ── fnm & Node ─────────────────────────────────────────────────────────
  for home in /root /home/*; do
    rm -rf "$home/.local/share/fnm"
    for rc in "$home/.bashrc" "$home/.zshrc"; do
      [[ -f $rc ]] && sed -i '/fnm env/d;/FNM_DIR/d' "$rc"
    done
  done

  # ── System tidy‑up ──────────────────────────────────────────────────────
  apt-get -y autoremove
  apt-get clean
}
cleanup

###############################################################################
# 2. Update system and install prerequisites                                #
###############################################################################
apt-get update -y && apt-get upgrade -y
apt-get install -y curl wget gnupg ca-certificates lsb-release software-properties-common

###############################################################################
# 3. Install Git                                                            #
###############################################################################
apt-get install -y git

###############################################################################
# 4. Install Visual Studio Code                                             #
###############################################################################
install_vscode() {
  echo "[INFO] Installing Visual Studio Code …"
  local KEYRING=/usr/share/keyrings/microsoft.gpg
  curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o "$KEYRING"
  echo "deb [arch=$(dpkg --print-architecture) signed-by=$KEYRING] https://packages.microsoft.com/repos/code stable main" \
    > /etc/apt/sources.list.d/vscode.list
  apt-get update -y
  apt-get install -y code
}
install_vscode

###############################################################################
# 5. Install fnm & Node.js v23                                              #
###############################################################################
NODE_VERSION="23"
install_fnm() {
  echo "[INFO] Installing fnm …"
  curl -fsSL https://fnm.vercel.app/install | bash

  export PATH="$HOME/.local/share/fnm:$PATH"
  eval "$(fnm env)"

  echo "[INFO] Installing Node.js v$NODE_VERSION via fnm …"
  fnm install "$NODE_VERSION"
  fnm default "$NODE_VERSION"

  local INIT='export PATH="$HOME/.local/share/fnm:$PATH"\nexport FNM_DIR="$HOME/.local/share/fnm"\neval "$(fnm env)"'
  for rc in "$HOME/.bashrc" "$HOME/.zshrc"; do
    if [[ -f $rc && $(grep -c "fnm env" "$rc") -eq 0 ]]; then
      printf "\n# Initialize fnm\n%s\n" "$INIT" >> "$rc"
    fi
  done
}
install_fnm

###############################################################################
# 6. Install Postman via snap                                               #
###############################################################################
install_postman() {
  echo "[INFO] Installing Postman …"
  if ! command -v snap >/dev/null; then
    apt-get install -y snapd
    systemctl enable --now snapd.socket
    ln -sf /var/lib/snapd/snap /snap
  fi
  snap install postman
}
install_postman

###############################################################################
# 7. Summary                                                                #
###############################################################################
cat <<EOF

✅  All done!
   • Git:      $(git --version)
   • VS Code:  $(code --version | head -1)
   • Node:     $(node --version)
   • Postman:  $(snap list postman | awk '/postman/{print $3}')

Reload your shell (source ~/.bashrc) or log out/in to use fnm.
EOF

