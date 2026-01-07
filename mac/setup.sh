#!/bin/bash

# --- 1. System & Homebrew ---
# Install Xcode Command Line Tools first
if ! xcode-select -p &> /dev/null; then
    echo "Installing Xcode Command Line Tools..."
    xcode-select --install
fi

if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# --- 2. Dotfiles & Symlinks ---
echo "Setting up Dotfiles..."
mkdir -p ~/h4kbas/ ~/.config
git clone git@github.com:h4kbas/dotfiles.git ~/h4kbas/dotfiles
git clone git@github.com:h4kbas/nvim.git ~/h4kbas/nvim

ln -sf ~/h4kbas/dotfiles/.zshrc ~/.zshrc
ln -sf ~/h4kbas/dotfiles/.zprofile ~/.zprofile
ln -sf ~/h4kbas/dotfiles/.gitconfig ~/.gitconfig
ln -sf ~/h4kbas/dotfiles/.inputrc ~/.inputrc
ln -sf ~/h4kbas/dotfiles/.tmux.conf ~/.tmux.conf
ln -sfn ~/h4kbas/nvim ~/.config/nvim
ln -sfn ~/h4kbas/dotfiles/wezterm ~/.config/wezterm

# --- 3. macOS Defaults ---
# (Keeping your keyboard repeat, trackpad, and Finder settings from previous version)
echo "Applying macOS settings..."
# ... [Insert the 'defaults write' commands from previous step here] ...

# --- 4. Development Languages & Tools ---
echo "Installing Languages..."
brew install node go gradle tmux nvim zsh-completions
brew install --cask android-commandlinetools

# Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path

# Cocoapods
sudo gem install cocoapods

# --- 5. Android SDK Setup ---
echo "Configuring Android..."
mkdir -p ~/.android && touch ~/.android/repositories.cfg
# Note: sdkmanager requires Java, which comes with Android Studio/OpenJDK
yes | sdkmanager --licenses
sdkmanager --update
sdkmanager "platform-tools" "platforms;android-28" "build-tools;28.0.3"

# --- 6. Flutter Setup ---
echo "Installing Flutter..."
mkdir -p ~/SDK
if [ ! -d "~/SDK/flutter" ]; then
    git clone https://github.com/flutter/flutter.git -b stable --depth 1 ~/SDK/flutter
fi
# Temporarily add to path for this session to run doctor
export PATH="$PATH:$HOME/SDK/flutter/bin"
flutter doctor

# --- 7. Applications ---
brew install --cask wezterm firefox spotify keka orbstack font-hack-nerd-font

# --- 8. Finalize ---
BREW_PREFIX=$(brew --prefix)
chmod -R 755 "${BREW_PREFIX}/share/zsh"
chown -R root:staff "${BREW_PREFIX}/share/zsh"

killall Finder Dock
echo "Setup complete! Please restart WezTerm."
