# --- Homebrew Initialization ---
# This must happen early so brew-installed tools are available in the PATH
eval "$(/opt/homebrew/bin/brew shellenv)"

# --- Environment Variables ---
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# History Settings
export HISTCONTROL=ignoreboth
export HISTSIZE=1000
export HISTFILESIZE=2000

# --- SDK & Language Paths ---

# Java & OpenJDK
# Note: If Android Studio JRE path fails, use: /opt/homebrew/opt/openjdk
export JAVA_HOME="/Applications/Android Studio.app/Contents/jre/Contents/Home"
export CPPFLAGS="-I/usr/local/opt/openjdk/include"

# Android
export ANDROID_HOME="$HOME/Library/Android/sdk"
export GRADLE_HOME="/opt/homebrew/opt/gradle"
export PATH="$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools"

# Flutter & Dart (Pub)
export PATH="$PATH:$HOME/SDK/flutter/bin"
export PATH="$PATH:$HOME/.pub-cache/bin"

# Go (Brew standard path + Workspace)
export GOPATH="$HOME/Workspace/go"
export PATH="$PATH:/usr/local/go/bin:$GOPATH/bin"

# Node.js (Homebrew usually handles this, but ensuring bin is present)
export PATH="/opt/homebrew/opt/node/bin:$PATH"

# Python
export PATH="/usr/local/opt/python@3.7/bin:$PATH"

# Bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Rust (Installed via rustup)
[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"

# --- Tool Integrations & Services ---

# OrbStack initialization
source ~/.orbstack/shell/init.zsh 2>/dev/null || :

# --- Theme & Appearance ---
export CLICOLOR=1
# Matches your WezTerm palette: Blue folders, Cyan symlinks
export LSCOLORS="exfxcxdxbxegedabagacad"
