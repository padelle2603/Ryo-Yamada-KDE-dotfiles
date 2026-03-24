# 🎸 Ryo Yamada's KDE Plasma Dotfiles

A minimalist, blue-toned KDE Plasma setup inspired by Ryo Yamada.
This configuration emphasizes a clean, efficient workflow, featuring:

- Fish Shell as the default shell
- Kvantum for consistent application theming
- Krohnkite for dynamic tiling window management
- KDE Round Corners for subtle visual polish
- Oh My Posh for a streamlined, informative terminal prompt

---

## 📸 Screenshots

<img src="https://i.imgur.com/6IT2CQE.png" width="500" height="300"> <img src="https://i.imgur.com/aJFiQXc.png" width="500" height="300"> <img src="https://i.imgur.com/B9mEnfh.png" width="500" height="300">

---
## 📁 Filesystem Structure

This repository follows the standard Linux directory hierarchy. Below is a breakdown of where each file belongs:

```
Ryo_Yamada/
├── .config/                         # Application-specific configurations
│   ├── alacritty/                   # GPU-accelerated terminal config
│   ├── fastfetch/                   # System info fetch styling
│   ├── fish/                        # Shell configuration & aliases
│   ├── Kvantum/                     # SVG-based theme engine configs
│   ├── oh-my-posh/                  # Terminal prompt themes
│   ├── kglobalshortcutsrc          # Custom Keybindings (Meta+K, Meta+Q, etc.)
│   ├── kwinrc                       # KWin & Krohnkite tiling rules
│   ├── libinput-gestures.conf       # Touchpad/Mouse gestures
│   └── plasma-org.kde.plasma.desktop-appletsrc # Desktop/Panel layout
├── .local/
│   └── share/                       # User data & theme assets
│       ├── aurorae/                 # Window decorations
│       ├── color-schemes/           # System color palettes
│       ├── konsole/                 # Terminal profiles
│       └── plasma/                  # Desktop widgets
├── Ryo_Yamada-sddm-login/           # Custom SDDM Login Screen Theme
└── Ryo_Yamada_Plasma_Style/         # Global Plasma Look-and-Feel Style
```

---

## 🛠️ Dependency Installation

The following packages are required for the theme and shell to function correctly. Choose the command that matches your distribution:

#### **Arch Linux**
```
sudo pacman -S --needed fastfetch fish fontconfig kvantum micro oh-my-posh libinput-gestures xsettingsd qt5-styleplugins qt6ct
```

#### **Fedora (KDE Spin)**
```
sudo dnf install fastfetch fish fontconfig kvantum micro xsettingsd qt5-qtstyleplugins qt6ct
# Note: oh-my-posh might require manual install via: 
# curl -s https://ohmyposh.dev/install.sh | bash -s
```

#### **Ubuntu / Debian / KDE Neon**
```
sudo apt update
sudo apt install fish fontconfig kvantum micro xsettingsd qt5-style-plugins qt6ct
# Note: fastfetch and oh-my-posh are best installed via their official GitHub releases or PPA.
```

#### **openSUSE (Tumbleweed)**
```
sudo zypper install fastfetch fish fontconfig kvantum micro xsettingsd qt6ct
```

---
## Plasmoids
List of plasmoids installed in `~/.local/share/plasma/plasmoids/`:

| Plasmoid (KDE Store Name) | Description |
|---------------------------|-------------|
| **Andromeda Launcher** | A simple, stylish application launcher for the KDE Plasma panel |
| **Apdatifier** | A system tray widget to check for and manage system updates|
| **Toggle Overview Widget for Plasma 6** | Adds a button to the panel or desktop to open the KDE Plasma Overview, which includes a powerful KRunner search box. |
| **Run Command** | A widget that adds a button to your panel or desktop to execute a custom terminal command with a single click. |
| **SysPeek** | A minimalist system monitor plasmoid that displays CPU, RAM, Swap, and network usage in a clean horizontal bar on the panel|
| **DateOnly** | A simple panel plasmoid that displays only the current date, without the time|
| **FairyWren App Menu** | A full-screen application menu for KDE Plasma, inspired by the macOS Launchpad. |
| **Audio Visualizer** | An animated plasmoid that visualizes audio playback in real-time on the panel. |
| **Panel Colorizer** | A tool to extensively customize the appearance and colors of your KDE Plasma panel|
| **Orbit Menu** | A circular, animated application launcher with a unique design for the panel |
| **Kara** | A widget designed for managing and displaying multimedia content. |
| **Media Controller Improved** | An enhanced media player controller with advanced playback controls and information display. |
| **Catwalkr** | A KDE Plasma widget that provides a window switcher in the style of a cover flow or carousel. |
| **Compact Shutdown** | A compact widget that provides quick access to shutdown, restart, and logout options. |
| **IP Address** | A simple plasmoid to display your local and public IP address on the panel. |
| **Shutdown or Switch** | A versatile button that gives easy access to power and session actions. |
| **Simple Kickoff** | A simplified, streamlined version of the default KDE Kickoff application launcher. |
| **Plasma Flex Hub** | A flexible hub widget for organizing shortcuts and other widgets. |
| **Simple Separator** | A minimalist visual separator widget for grouping items in the KDE Plasma panel. |

---
## Manual Installation

If you prefer to move the files yourself, follow these steps:

1. **Backup your current config:** 
```
cp -r ~/.config ~/.config.backup
cp -r ~/.local/share ~/.local/share.backup
```

2. **Copy Configuration files:**
```
cp -r .config/* ~/.config/
```

3. **Copy Data files:**
```
cp -r .local/share/* ~/.local/share/
```

4. **Apply Theme:**
    - Open **System Settings** > **Colors** and select the Ryo-themed scheme.
    - Open **Kvantum Manager** and select the theme from the list.
    - Restart your Plasma session (Log out and Log in).

---
## Konsave file
If you feel safer using [konsave](https://github.com/Prayag2/konsave) you can import the theme using a .knsv [here](https://mega.nz/file/p3IlET4D#ys3_K5JpI6ku3TheeUVHwzX8d3pRLxBp56kJkCTtGZM).

---
## ⌨️ Custom Keybindings

These shortcuts are defined in `kglobalshortcutsrc` and `kwinrc`. If you are importing manually, ensure these don't conflict with your existing global shortcuts.

|**Action**|**Shortcut**|
|---|---|
|**Open Terminal (Alacritty)**|`Meta` + `K`|
|**Open File Manager (Dolphin)**|`Meta` + `E`|
|**Close Active Window**|`Meta` + `Q`|
|**Maximize**|`Meta` + `F`|
|**Open Boot/Leave Menu**|`Meta` + `Del`|
|**Search (KRunner)**|`Meta` (Tap)|
|**Screenshot (Selection)**|`Shift` + `ù`|
|**Krohnkite: BTree Layout**|`Meta` + `Shift` + `PgUp`|
|**Krohnkite: Floating Layout**|`Meta` + `Shift` + `PgDn`|
