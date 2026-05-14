#!/usr/bin/env bash
set -e

# =============================================================
# macOS setup script for h4kbas/dotfiles
# Run on a fresh OS. Re-running is mostly idempotent.
# =============================================================

DOTFILES_DIR="$HOME/h4kbas/dotfiles"
NVIM_DIR="$HOME/h4kbas/nvim"

# --- 1. Xcode Command Line Tools ---
if ! xcode-select -p &> /dev/null; then
    echo "Installing Xcode Command Line Tools..."
    xcode-select --install
    until xcode-select -p &> /dev/null; do sleep 5; done
fi

# --- 2. Homebrew ---
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$(/opt/homebrew/bin/brew shellenv)"

# --- 3. macOS Defaults ---
# Values mirror current personal setup. Adjust as needed.
echo "Applying macOS settings..."

# Appearance: Dark mode
defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"

# Keyboard: fastest repeat, press-and-hold off
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 10
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Typing: kill autocorrect/smart substitutions (keep spelling underline)
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

# Trackpad: tap to click, three-finger drag, light click pressure
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
defaults write com.apple.AppleMultitouchTrackpad FirstClickThreshold -int 2
defaults write com.apple.AppleMultitouchTrackpad SecondClickThreshold -int 2
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true
defaults write -g com.apple.mouse.tapBehavior -int 1
defaults write -g com.apple.trackpad.scaling -float 3
defaults write -g com.apple.swipescrolldirection -bool false

# Windows: don't minimize on double-click title bar
defaults write NSGlobalDomain AppleMiniaturizeOnDoubleClick -bool false

# Finder
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool false
defaults write com.apple.finder FXPreferredViewStyle -string "icnv"
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
defaults write com.apple.finder NewWindowTarget -string "PfAF"
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

# Dock: stay visible, small icons, big magnification, no recents, no app launch bounce
defaults write com.apple.dock autohide -bool false
defaults write com.apple.dock tilesize -int 40
defaults write com.apple.dock largesize -int 128
defaults write com.apple.dock launchanim -bool false
defaults write com.apple.dock mru-spaces -bool false
defaults write com.apple.dock expose-animation-duration -float 0.1
defaults write com.apple.dock show-recents -bool false
# Hot corner: bottom-right = Quick Note (14)
defaults write com.apple.dock wvous-br-corner -int 14
defaults write com.apple.dock wvous-br-modifier -int 0

# Screenshots: selection mode, allow video
defaults write com.apple.screencapture style -string "selection"
defaults write com.apple.screencapture video -bool true

# Disable .DS_Store on network/USB
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Spring loading for folders
defaults write NSGlobalDomain com.apple.springing.enabled -bool true
defaults write NSGlobalDomain com.apple.springing.delay -float 0.5

# Save dialogs expanded by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# --- 4. Dotfiles & Symlinks ---
echo "Setting up dotfiles..."
mkdir -p "$HOME/h4kbas" "$HOME/.config"

if [ ! -d "$DOTFILES_DIR" ]; then
    git clone https://github.com/h4kbas/dotfiles.git "$DOTFILES_DIR"
fi
if [ ! -d "$NVIM_DIR" ]; then
    git clone https://github.com/h4kbas/nvim.git "$NVIM_DIR"
fi

ln -sf  "$DOTFILES_DIR/.zshrc"     "$HOME/.zshrc"
ln -sf  "$DOTFILES_DIR/.zprofile"  "$HOME/.zprofile"
ln -sf  "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"
ln -sf  "$DOTFILES_DIR/.gitignore" "$HOME/.gitignore"
ln -sf  "$DOTFILES_DIR/.inputrc"   "$HOME/.inputrc"
ln -sf  "$DOTFILES_DIR/.tmux.conf" "$HOME/.tmux.conf"
ln -sfn "$NVIM_DIR"                "$HOME/.config/nvim"
ln -sfn "$DOTFILES_DIR/wezterm"    "$HOME/.config/wezterm"
ln -sfn "$DOTFILES_DIR/alacritty"  "$HOME/.config/alacritty"
ln -sfn "$DOTFILES_DIR/lazygit"    "$HOME/.config/lazygit"
ln -sfn "$DOTFILES_DIR/yazi"       "$HOME/.config/yazi"
mkdir -p "$HOME/.config/dooit"
ln -sf  "$DOTFILES_DIR/dooit/config.py" "$HOME/.config/dooit/config.py"

# --- 5. Brew Formulas ---
echo "Installing CLI tools..."
brew install \
    git \
    git-delta \
    lazygit \
    neovim \
    tmux \
    node \
    go \
    gradle \
    fzf \
    ripgrep \
    fd \
    yazi \
    rich-cli \
    ncdu \
    wget \
    gnupg \
    pinentry-mac \
    posting \
    rainfrog \
    dooit \
    cocoapods \
    fastlane \
    rustup \
    zsh-completions

# dooit config imports dooit_extras; install into Homebrew dooit venv (not system Python)
if command -v brew &>/dev/null && brew --prefix dooit &>/dev/null; then
    _dooit_py="$(brew --prefix dooit)/libexec/bin/python"
    if [ -x "$_dooit_py" ]; then
        "$_dooit_py" -m pip install --upgrade "dooit-extras" || true
    fi
fi

if ! command -v rustc &> /dev/null; then
    rustup-init -y --no-modify-path
fi

# --- 6. Brew Casks (GUI apps) ---
echo "Installing apps..."
brew install --cask \
    wezterm \
    alacritty \
    font-hack-nerd-font \
    google-chrome \
    firefox \
    spotify \
    slack \
    telegram \
    signal \
    obsidian \
    cursor-cli \
    neovide \
    claude-code \
    docker \
    orbstack \
    fuse-t \
    keka \
    caffeine \
    battery-toolkit \
    calibre \
    pgadmin4 \
    runjs \
    tailscale-app \
    ledger-live \
    steam \
    inkscape \
    godot \
    wine-stable

# --- 7. Android SDK ---
echo "Configuring Android..."
brew install --cask android-commandlinetools
mkdir -p "$HOME/.android" && touch "$HOME/.android/repositories.cfg"
yes | sdkmanager --licenses || true
sdkmanager --update || true
sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0" || true

# --- 8. Tmux plugins (TPM) ---
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi

# --- 8b. Yazi plugins ---
if command -v ya &> /dev/null; then
    ya pkg install || true
fi

# --- 9. Finalize ---
BREW_PREFIX=$(brew --prefix)
chmod -R 755 "${BREW_PREFIX}/share/zsh" || true
chown -R "$(whoami):staff" "${BREW_PREFIX}/share/zsh" || true

killall Finder Dock SystemUIServer 2>/dev/null || true

echo ""
echo "Setup complete. Restart terminal."
echo "Next: generate SSH/GPG keys manually and add to GitHub."
