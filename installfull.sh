#!/usr/bin/env bash

set -euo pipefail

bold="\033[1m"
green="\033[32m"
yellow="\033[33m"
reset="\033[0m"

info() { echo -e "${bold}[*]${reset} $1"; }
ok()   { echo -e "${green}[✓]${reset} $1"; }
warn() { echo -e "${yellow}[!]${reset} $1"; }

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP="$HOME/.rice-backup-$(date +%Y%m%d_%H%M%S)"

# ---------- Step 1: apps ----------
info "Running install-apps-only..."
"$REPO_DIR/install-apps-only"

# ---------- Step 2: Oh My Zsh ----------
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  info "Installing Oh My Zsh..."
  export RUNZSH=no
  export CHSH=no
  if command -v curl >/dev/null 2>&1; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    ok "Oh My Zsh installed."
  else
    warn "curl not found – cannot auto-install Oh My Zsh."
  fi
else
  ok "Oh My Zsh already installed."
fi

# ---------- Step 3: p10k + plugins ----------
if [[ -d "$HOME/.oh-my-zsh" ]]; then
  ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

  clone_if_missing() {
    local repo="$1" dest="$2" name="$3"
    if [[ ! -d "$dest" ]]; then
      info "Installing $name..."
      git clone --depth=1 "$repo" "$dest"
      ok "$name installed."
    else
      ok "$name already present."
    fi
  }

  clone_if_missing "https://github.com/romkatv/powerlevel10k.git" \
    "$ZSH_CUSTOM/themes/powerlevel10k" "Powerlevel10k"

  clone_if_missing "https://github.com/zsh-users/zsh-autosuggestions.git" \
    "$ZSH_CUSTOM/plugins/zsh-autosuggestions" "zsh-autosuggestions"

  clone_if_missing "https://github.com/zsh-users/zsh-syntax-highlighting.git" \
    "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" "zsh-syntax-highlighting"
else
  warn "Oh My Zsh directory not found; skipping theme/plugins setup."
fi

# ---------- Step 4: backup dir ----------
info "Creating backup directory: $BACKUP"
mkdir -p "$BACKUP"

# ---------- helper for linking configs ----------
link_config() {
  local src="$1"
  local dst="$2"
  local name="$3"

  if [[ -e "$dst" && ! -L "$dst" ]]; then
    info "Backing up $name → $BACKUP"
    mv "$dst" "$BACKUP/"
  fi

  ln -sf "$src" "$dst"
  ok "$name linked."
}

# ---------- Step 5: .zshrc ----------
if [[ -f "$REPO_DIR/.zshrc" ]]; then
  link_config "$REPO_DIR/.zshrc" "$HOME/.zshrc" ".zshrc"
else
  warn "No .zshrc in repo; skipping .zshrc link."
fi

# ---------- Step 6: .config/* ----------
mkdir -p "$HOME/.config"

for d in btop cava fastfetch wal wezterm wlogout wofi; do
  if [[ -d "$REPO_DIR/.config/$d" ]]; then
    link_config "$REPO_DIR/.config/$d" "$HOME/.config/$d" "$d config"
  else
    warn "No .config/$d in repo; skipping."
  fi
done

# ---------- Step 7: scripts ----------
if [[ -d "$REPO_DIR/.script" ]]; then
  info "Installing scripts to ~/.local/bin"
  mkdir -p "$HOME/.local/bin"
  for f in "$REPO_DIR/.script/"*; do
    [[ -f "$f" ]] || continue
    base="$(basename "$f")"
    # backup old script if exists
    if [[ -e "$HOME/.local/bin/$base" && ! -L "$HOME/.local/bin/$base" ]]; then
      info "Backing up existing ~/.local/bin/$base → $BACKUP/$base"
      mv "$HOME/.local/bin/$base" "$BACKUP/$base"
    fi
    cp "$f" "$HOME/.local/bin/$base"
    chmod +x "$HOME/.local/bin/$base"
  done
  ok "Scripts installed."
else
  warn "No .script directory in repo; skipping scripts."
fi

# ---------- Step 8: Wallpaper ----------
if [[ -d "$REPO_DIR/Wallpaper" ]]; then
  info "Copying wallpapers to ~/Pictures/Wallpapers"
  mkdir -p "$HOME/Pictures/Wallpapers"
  cp -n "$REPO_DIR/Wallpaper/"* "$HOME/Pictures/Wallpapers/" 2>/dev/null || true
  ok "Wallpapers copied."
else
  warn "No Wallpaper directory in repo; skipping."
fi

# ---------- Step 9: images ----------
if [[ -d "$REPO_DIR/images" ]]; then
  info "Copying images to ~/Pictures/RiceImages"
  mkdir -p "$HOME/Pictures/RiceImages"
  cp -n "$REPO_DIR/images/"* "$HOME/Pictures/RiceImages/" 2>/dev/null || true
  ok "Images copied."
else
  warn "No images directory in repo; skipping."
fi

echo
ok "FULL INSTALL COMPLETE ✅"
echo
echo "Backups stored in: $BACKUP"
echo
echo "Manual steps:"
echo "- Set default shell to zsh (optional):  chsh -s \"\$(command -v zsh)\""
echo "- Log out and log back in"
echo "- Enable GNOME extensions you installed from https://extensions.gnome.org"
echo "- Set wallpaper from ~/Pictures/Wallpapers if not auto-applied"

