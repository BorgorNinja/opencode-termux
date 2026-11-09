#!/bin/sh
# OpenCode Native Termux Auto-Installer
# BorgorNinja/opencode-termux
set -eu

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "${BLUE}==> OpenCode Termux Native Installer${NC}"

# Check environment
if [ -z "${PREFIX:-}" ] && [ ! -d "/data/data/com.termux/files/usr" ]; then
    echo "${RED}Error: This script must be run inside Termux on Android.${NC}" >&2
    exit 1
fi
PREFIX="${PREFIX:-/data/data/com.termux/files/usr}"

# Check architecture
ARCH="$(uname -m)"
if [ "$ARCH" != "aarch64" ]; then
    echo "${RED}Error: Native Bionic build requires aarch64 (ARM64). Detected: $ARCH${NC}" >&2
    exit 1
fi

VERSION="2.0.31"
REPO="BorgorNinja/opencode-termux"
DEB_URL="https://github.com/${REPO}/releases/download/v${VERSION}/opencode_${VERSION}_aarch64.deb"
TMP_DEB="/data/data/com.termux/files/usr/tmp/opencode_${VERSION}_aarch64.deb"

mkdir -p "$(dirname "$TMP_DEB")"

echo "${BLUE}==> Downloading OpenCode v${VERSION} .deb package...${NC}"
curl -fL --progress-bar "$DEB_URL" -o "$TMP_DEB"

echo "${BLUE}==> Installing package via dpkg...${NC}"
dpkg -i "$TMP_DEB"
rm -f "$TMP_DEB"

echo "${BLUE}==> Applying mobile keyboard & display optimizations...${NC}"
CONFIG_DIR="$HOME/.config/opencode"
mkdir -p "$CONFIG_DIR"

if [ ! -f "$CONFIG_DIR/cli.json" ]; then
    cat << 'EOF' > "$CONFIG_DIR/cli.json"
{
  "$schema": "https://opencode.ai/v2/cli.json",
  "keybinds": {
    "agent.cycle": "tab",
    "agent.cycle.reverse": "shift+tab"
  }
}
EOF
fi

BASHRC="$HOME/.bashrc"
if [ ! -f "$BASHRC" ] || ! grep -q "COLORTERM=truecolor" "$BASHRC"; then
    cat << 'EOF' >> "$BASHRC"

# OpenCode TUI settings
export TERM=xterm-256color
export COLORTERM=truecolor
EOF
fi

echo "${GREEN}==> Installation completed!${NC}"
opencode --version || true
echo "Run 'opencode' to start."
