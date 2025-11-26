# abzero-rice

My personal **ricing setup** for Linux (Arch / Fedora / Ubuntu).

This repo includes:

- GNOME theming + extensions (installed manually)
- WezTerm terminal config
- pywal color generation + theme syncing
- Fastfetch theme
- Wofi styling
- Wlogout theme
- Scripts for wallpaper + color syncing
- Zsh + Oh My Zsh + Powerlevel10k
- Wallpapers and images

---

## 🚀 Quick Setup (Recommended)

```bash
git clone https://github.com/sureshwarkesiraju/abzero-rice.git ~/.abzero-rice
cd ~/.abzero-rice
./installfull.sh
```

This will:

- ✅ Install required applications
- ✅ Install zsh + oh-my-zsh + powerlevel10k
- ✅ Create backups of existing configs
- ✅ Link configs into `~/.config`
- ✅ Install scripts into `~/.local/bin`
- ✅ Copy wallpapers and images

Backups are stored in:

```
~/.rice-backup-YYYYMMDD_HHMMSS
```

---

##  Option B — Apps Only

If you only want to install applications:

```bash
./install-apps-only.sh
```

This installs:

- zsh
- wezterm
- cava
- btop
- fastfetch
- wlogout
- nautilus
- pywal
- gnome-shell-extensions
- curl + git + dependencies

Does **NOT**:

-  touch config files
-  install themes
-  install scripts
-  copy wallpapers

---

##  Wallpapers

Wallpapers are copied to:

```
~/Pictures/Wallpapers
```

(or your GNOME shortcut) to:

- set wallpaper
- regenerate pywal theme
- recolor:

  - wezterm
  - wlogout
  - fastfetch
  - cava
  - wofi

---

## ⌨️ Keyboard Shortcuts (Manual Setup)

Set these in:

```
Settings → Keyboard → Custom Shortcuts
```

| Name             | Command                                   | Shortcut  |
|------------------|-------------------------------------------|-----------|
| File Manager     | `nautilus`                                | Super + E |
| Wallpaper Picker | `~/.local/bin/wallpaper-picker.sh`        | Alt + W   |
| WezTerm          | `wezterm`                                 | Super + T |
| wlogout          | `wlogout`                                 | Alt + L   |
| wofi             | `wofi`                                    | Alt + F   |

> Keybindings are **not** automatically created by the scripts.

---

##  GNOME Extensions (Manual)

Install from:

https://extensions.gnome.org

Recommended:

- Blur My Shell
- Just Perfection
- Open Bar
- System Monitor
- Move Workspace Indicator
- Unblank
- Workspace Indicator

---

##  Directory Structure

```text
abzero-rice
├─ .config/
│  ├─ btop
│  ├─ cava
│  ├─ fastfetch
│  ├─ wal
│  ├─ wezterm
│  ├─ wlogout
│  └─ wofi
├─ .script/
│  ├─ fastfetch_auto.sh
│  ├─ wallpaper-picker.sh
│  └─ (other helper scripts)
├─ Wallpaper/
├─ images/
├─ .zshrc
├─ installfull.sh
└─ install-apps-only.sh
```

---

##  Notes

If wallpaper-picker fails to set your wallpaper, rename files to include a prefix:

```
SomeExample_.png
Something_.jpg
```

---

## Author

Sureshwar Kesiraju

