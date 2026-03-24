# 🎸 Ryo Yamada's KDE Plasma Dotfiles

A minimalist, blue-toned KDE Plasma setup inspired by **Ryo Yamada**. This configuration focuses on a clean workflow using **Fish Shell**, **Kvantum** for styling, and **Oh My Posh** for the terminal prompt.

---

## 📸 Screenshots

<img src="https://i.imgur.com/6IT2CQE.png" alt="Descrizione" width="500" height="300">
<img src="https://imgur.com/B9mEnfh" alt="Descrizione" width="500" height="300">
<img src="ttps://imgur.com/aJFiQXc" alt="Descrizione" width="500" height="300">

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
## ⌨️ Custom Keybindings

These shortcuts are defined in `kglobalshortcutsrc` and `kwinrc`. If you are importing manually, ensure these don't conflict with your existing global shortcuts.

|**Action**|**Shortcut**|
|---|---|
|**Open Terminal (Alacritty)**|`Meta` + `K`|
|**Open File Manager (Dolphin)**|`Meta` + `E`|
|**Close Active Window**|`Meta` + `Q`|
|**Open Boot/Leave Menu**|`Meta` + `Del`|
|**Search (KRunner)**|`Meta` (Tap)|
|**Screenshot (Selection)**|`Shift` + `ù`|
|**Krohnkite: BTree Layout**|`Meta` + `Shift` + `PgUp`|
|**Krohnkite: Floating Layout**|`Meta` + `Shift` + `PgDn`|

---
# Ryo-Yamada-KDE-dotfiles
# Ryo-Yamada-KDE-dotfiles
# Ryo-Yamada-KDE-dotfiles
# Ryo-Yamada-KDE-dotfiles
# Ryo-Yamada-KDE-dotfiles
