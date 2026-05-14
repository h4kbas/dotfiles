#!/usr/bin/env bash
set -euo pipefail

# Backs up local state for tools installed via mac/setup.sh (and related paths).
# Default output: ~/h4kbas/backups/backup-YYYYMMDD-HHMMSS
# Override: BACKUP_ROOT=/path/to/dir ./backup.sh

BACKUP_ROOT="${BACKUP_ROOT:-$HOME/h4kbas/backups/backup-$(date +%Y%m%d-%H%M%S)}"
MANIFEST="$BACKUP_ROOT/MANIFEST.txt"

mkdir -p "$BACKUP_ROOT"
{
  echo "backup started $(date -Iseconds)"
  echo "host $(hostname 2>/dev/null || true)"
  echo "user $USER"
} >"$MANIFEST"

log() {
  echo "$*" | tee -a "$MANIFEST"
}

# $1 = label under BACKUP_ROOT, $2 = source path (dir or file)
backup_into() {
  local label src dest
  label="$1"
  src="$2"
  dest="$BACKUP_ROOT/$label"
  if [[ -e "$src" ]]; then
    mkdir -p "$(dirname "$dest")"
    if [[ -d "$src" ]]; then
      mkdir -p "$dest"
      rsync -a "$src"/ "$dest"/
      log "OK DIR  $src -> $dest"
    else
      cp -a "$src" "$dest"
      log "OK FILE $src -> $dest"
    fi
  else
    log "SKIP (missing) $src"
  fi
}

# rsync dir with excludes (relative to src)
backup_dir_excludes() {
  local label src
  label="$1"
  src="$2"
  shift 2
  local dest="$BACKUP_ROOT/$label"
  if [[ -d "$src" ]]; then
    mkdir -p "$dest"
    rsync -a "$@" "$src"/ "$dest"/
    log "OK DIR  $src -> $dest (with excludes)"
  else
    log "SKIP (missing) $src"
  fi
}

log "BACKUP_ROOT=$BACKUP_ROOT"

# --- Neovim (skip lazy.nvim + Mason; reinstall with nvim) ---
if [[ -d "$HOME/.local/share/nvim" ]]; then
  backup_dir_excludes nvim-local-share "$HOME/.local/share/nvim" \
    --exclude 'lazy/' --exclude 'mason/'
fi
backup_into nvim-local-state "$HOME/.local/state/nvim"

# --- tmux (TPM + plugin state) ---
backup_into tmux "$HOME/.tmux"

# --- lazygit (repo list etc.; config is in dotfiles) ---
backup_into lazygit-local-state "$HOME/.local/state/lazygit"

# --- yazi (history, etc.; plugins live under ~/.config/yazi via symlink) ---
backup_into yazi-local-state "$HOME/.local/state/yazi"
backup_into yazi-local-share "$HOME/.local/share/yazi"

# --- posting (collections, themes per XDG) ---
backup_into posting-local-share "$HOME/.local/share/posting"
backup_into posting-config "$HOME/.config/posting"

# --- matcha (https://docs.matcha.floatpane.com/Configuration) ---
backup_into matcha-config "$HOME/.config/matcha"
backup_into matcha-cache "$HOME/.cache/matcha"

# --- rainfrog ---
backup_into rainfrog-config "$HOME/.config/rainfrog"

# --- dooit (todo DB + extras; config.py is symlinked from dotfiles) ---
backup_into dooit-local-share "$HOME/.local/share/dooit"
backup_into dooit-config "$HOME/.config/dooit"
backup_into dooit-app-support "$HOME/Library/Application Support/dooit"

log "backup finished $(date -Iseconds)"
log "size $(du -sh "$BACKUP_ROOT" | awk '{print $1}')"
echo ""
echo "Done: $BACKUP_ROOT"
echo "Read MANIFEST.txt inside for what was copied."
