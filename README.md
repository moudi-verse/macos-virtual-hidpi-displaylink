# macOS Virtual HiDPI DisplayLink Setup

Virtual HiDPI workaround for sharper DisplayLink monitors on macOS.

## Features

- Creates a virtual HiDPI display
- Mirrors it to a DisplayLink monitor
- Improves text sharpness
- Automatically restores setup at login

## Final Display Mode

| Type | Resolution |
|---|---|
| Logical HiDPI | 2048×1152 |
| Backing Resolution | 4096×2304 |

## Files

| File | Purpose |
|---|---|
| `virtual_hidpi_display.m` | Creates the virtual display |
| `start.sh` | Starts virtual display and restores layout |

---

# Setup Instructions

## 1. Create project folder

```bash
mkdir -p ~/virtual-hidpi
cd ~/virtual-hidpi
```

## 2. Copy repository files

Copy these files into:

```text
~/virtual-hidpi/
```

- `virtual_hidpi_display.m`
- `start.sh`

---

## 3. Compile the virtual display executable

```bash
clang -fobjc-arc \
-framework Foundation \
-framework AppKit \
-framework CoreGraphics \
-o virtual_hidpi_display \
virtual_hidpi_display.m
```

---

## 4. Test the virtual display

```bash
./virtual_hidpi_display
```

Expected output:

```text
Created virtual display...
Logical HiDPI mode: 2048x1152
Backing resolution: 4096x2304
```

Keep the process running.

---

## 5. Mirror the DisplayLink monitor

Open:

```text
System Settings → Displays
```

Mirror the DisplayLink monitor to:

```text
Virtual Retina 27
```

---

## 6. Install displayplacer

Install Homebrew if needed:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Install displayplacer:

```bash
brew install displayplacer
```

---

## 7. Capture your layout

While the virtual display is running:

```bash
displayplacer list
```

Copy the generated `displayplacer` command.

---

## 8. Edit start.sh

Replace the placeholder `displayplacer` command with your own generated command.

Example:

```bash
#!/bin/zsh

cd ~/virtual-hidpi

# start virtual display
./virtual_hidpi_display &

# wait for macOS to register it
sleep 3

# apply your layout
displayplacer "YOUR_DISPLAYPLACER_COMMAND"
```

---

## 9. Make scripts executable

```bash
chmod +x start.sh
```

---

## 10. Run the setup

```bash
./start.sh
```

---

# Optional Auto-Start

Open:

```text
Script Editor
```

Paste:

```applescript
do shell script "/Users/YOUR_USERNAME/github/macos-virtual-hidpi-displaylink/start.sh &"
```

Replace:

```text
YOUR_USERNAME
```

with your actual macOS username.

Save as:

```text
VirtualHiDPI.app
```

File format:

```text
Application
```

Move it to:

```text
/Applications
```

(Optional) Hide the Dock icon:

```bash
defaults write /Applications/VirtualHiDPI.app/Contents/Info LSUIElement -bool true
killall Dock
```

Then add it to:

```text
System Settings → General → Login Items
```

---

# Final Folder Structure

```text
~/virtual-hidpi/
├── start.sh
├── virtual_hidpi_display.m
└── virtual_hidpi_display
```

And:

```text
/Applications/VirtualHiDPI.app
```

---

# Notes

This is a workaround using private macOS display APIs.

Possible downsides:

- may break after macOS updates
- some lag may remain (I don't have any lags)
- display IDs may differ between Macs

# Extra Note

To kill the virtual display - use this command 

```text
pkill -f virtual_hidpi_display
```
