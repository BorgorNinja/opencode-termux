# opencode-termux

OpenCode native Bionic port and `.deb` distribution for Android Termux (`aarch64`).

This repository packages [OpenCode](https://opencode.ai) for native execution inside Termux with zero glibc or PRoot container requirements.

## Quick Install

### Method 1: Download & Install Debian Package (Recommended)

Run directly in Termux:

```bash
# Download latest aarch64 deb release
curl -sLO https://github.com/BorgorNinja/opencode-termux/releases/download/v2.0.31/opencode_2.0.31_aarch64.deb

# Install via dpkg
dpkg -i opencode_2.0.31_aarch64.deb

# Clean up
rm opencode_2.0.31_aarch64.deb
```

### Method 2: One-Line Installer Script

```bash
curl -fsSL https://raw.githubusercontent.com/BorgorNinja/opencode-termux/main/install.sh | bash
```

---

## Why Native Bionic?

Standard upstream OpenCode binaries target GNU/Linux and musl (`/lib/ld-linux-aarch64.so.1` or `/lib/ld-musl-aarch64.so.1`). On Android Termux:

1. **Dynamic Linker**: Android uses `/system/bin/linker64` rather than standard GNU linkers. Running upstream binaries directly results in `No such file or directory` (ENOENT).
2. **C Runtime**: Android uses Bionic libc instead of glibc. Precompiled Node addons and native C++ shared libraries fail to resolve glibc symbols.
3. **True Native Performance**: This release compiles and links OpenCode against Android NDK API 28+ Bionic headers, enabling zero-container, zero-emulation execution directly in Termux.

---

## Mobile Keyboard & Display Fixes

### 1. Shift+Tab Keybind Fix (Agent Cycling)

OpenCode v2 maps `agent.cycle` (switching between plan and build agents) to `Shift+Tab`. Mobile keyboards (Gboard, Samsung Keyboard, Termux touch bar) cannot emit `Shift+Tab`.

Add or update `~/.config/opencode/cli.json`:

```json
{
  "$schema": "https://opencode.ai/v2/cli.json",
  "keybinds": {
    "agent.cycle": "tab",
    "agent.cycle.reverse": "shift+tab"
  }
}
```

*Note: In OpenCode v2, `tab` is unbound by default so it has zero conflicts.*

### 2. Android Phantom Process Killer

Android 12+ terminates background apps that spawn excessive subprocesses. To prevent unexpected shutdowns during long autonomous coding sessions:

1. Enable wake lock inside Termux:
   ```bash
   termux-wake-lock
   ```
2. Disable phantom process limits via ADB (run once from a computer or local wireless ADB):
   ```bash
   adb shell /system/bin/device_config put activity_manager max_phantom_processes 2147483647
   adb shell /system/bin/device_config set_sync_disabled_for_tests persistent
   ```

### 3. TUI Colors (Truecolor)

Add the following to your `~/.bashrc`:

```bash
export TERM=xterm-256color
export COLORTERM=truecolor
```

---

## Verification

After installation, verify the binary and its dynamic linker:

```bash
# 1. Check dynamic interpreter
file $(which opencode)
# Output should indicate: ELF 64-bit LSB pie executable, ARM aarch64, interpreter /system/bin/linker64

# 2. Check version
opencode --version

# 3. Launch OpenCode
opencode
```

---

## License

MIT License. OpenCode is open source.
