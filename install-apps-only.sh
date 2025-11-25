#!/usr/bin/env bash

set -u

# Simple logging helpers
bold="\033[1m"
green="\033[32m"
yellow="\033[33m"
red="\033[31m"
reset="\033[0m"

info() { echo -e "${bold}[*]${reset} $1"; }
ok()   { echo -e "${green}[✓]${reset} $1"; }
warn() { echo -e "${yellow}[!]${reset} $1"; }
err()  { echo -e "${red}[x]${reset} $1"; }

require_file() {
  if [[ ! -f "$1" ]]; then
    err "Required file '$1' not found. Exiting."
    exit 1
  fi
}

detect_distro() {
  require_file "/etc/os-release"
  . /etc/os-release
  local id like
  id="${ID,,}"
  like="${ID_LIKE,,}"

  if [[ "$id" == "arch" || "$like" == *"arch"* ]]; then
    echo "arch"
  elif [[ "$id" == "fedora" || "$like" == *"fedora"* ]]; then
    echo "fedora"
  elif [[ "$id" == "ubuntu" || "$id" == "debian" || "$like" == *"debian"* || "$like" == *"ubuntu"* ]]; then
    echo "debian"
  else
    echo "unsupported"
  fi
}

install_arch() {
  info "Updating package database (pacman)..."
  sudo pacman -Syu --noconfirm | cat

  local packages=(
    zsh
    curl
    git
    jq
    imagemagick
    python-pywal
    wezterm
    cava
    btop
    fastfetch
    wlogout
    nautilus
    gnome-shell-extensions
  )

  for pkg in "${packages[@]}"; do
    info "Installing $pkg..."
    if sudo pacman -S --needed --noconfirm "$pkg" | cat; then
      ok "$pkg installed"
    else
      warn "Failed to install $pkg"
    fi
  done
}

install_fedora() {
  info "Updating packages (dnf)..."
  sudo dnf -y upgrade --refresh | cat

  local packages=(
    zsh
    curl
    git
    jq
    ImageMagick
    python3-pywal
    wezterm
    cava
    btop
    fastfetch
    wlogout
    nautilus
    gnome-shell-extensions
  )

  for pkg in "${packages[@]}"; do
    info "Installing $pkg..."
    if sudo dnf -y install "$pkg" | cat; then
      ok "$pkg installed"
    else
      warn "Failed to install $pkg"
      if [[ "$pkg" == "wezterm" ]]; then
        warn "Hint: enable WezTerm COPR: sudo dnf copr enable wezfurlong/wezterm -y && sudo dnf install wezterm -y"
      fi
    fi
  done
}

install_debian() {
  info "Updating package lists (apt)..."
  sudo apt-get update -y | cat
  info "Upgrading installed packages (apt)..."
  sudo apt-get upgrade -y | cat

  local packages=(
    zsh
    curl
    git
    jq
    imagemagick
    python3-pywal
    wezterm
    cava
    btop
    fastfetch
    wlogout
    nautilus
    gnome-shell-extensions
  )

  for pkg in "${packages[@]}"; do
    info "Installing $pkg..."
    if sudo apt-get install -y "$pkg" | cat; then
      ok "$pkg installed"
    else
      warn "Failed to install $pkg"
      if [[ "$pkg" == "wezterm" ]]; then
        warn "Hint: install WezTerm .deb manually from official releases."
      fi
    fi
  done
}

main() {
  info "Detecting Linux distribution..."
  distro="$(detect_distro)"

  case "$distro" in
    arch)
      ok "Detected Arch Linux"
      install_arch
      ;;
    fedora)
      ok "Detected Fedora"
      install_fedora
      ;;
    debian)
      ok "Detected Ubuntu/Debian"
      install_debian
      ;;
    *)
      err "Unsupported Linux distribution. Exiting."
      exit 1
      ;;
  esac

  echo
  ok "Application install finished."
  warn "Manual step: install GNOME extensions from https://extensions.gnome.org if desired."
}

main "$@"

