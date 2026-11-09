#!/bin/sh
# Build .deb package for Termux
set -eu

VERSION="2.0.31"
ARCH="aarch64"
PKG_DIR="/tmp/opencode_deb_build"

rm -rf "$PKG_DIR"
mkdir -p "$PKG_DIR/DEBIAN"
mkdir -p "$PKG_DIR/data/data/com.termux/files/usr/bin"
mkdir -p "$PKG_DIR/data/data/com.termux/files/usr/lib/opencode"

cp DEBIAN/control "$PKG_DIR/DEBIAN/"
cp DEBIAN/postinst "$PKG_DIR/DEBIAN/"
chmod 755 "$PKG_DIR/DEBIAN/postinst"

# Assume binaries are available in local cache or build tree
if [ -f "/tmp/deb_test/extracted/data/data/com.termux/files/usr/bin/opencode" ]; then
    cp "/tmp/deb_test/extracted/data/data/com.termux/files/usr/bin/opencode" "$PKG_DIR/data/data/com.termux/files/usr/bin/"
    cp "/tmp/deb_test/extracted/data/data/com.termux/files/usr/lib/opencode/libopencode-crhandler.so" "$PKG_DIR/data/data/com.termux/files/usr/lib/opencode/"
    chmod 755 "$PKG_DIR/data/data/com.termux/files/usr/bin/opencode"
    dpkg-deb --build "$PKG_DIR" "opencode_${VERSION}_${ARCH}.deb"
    echo "Built opencode_${VERSION}_${ARCH}.deb successfully."
fi
