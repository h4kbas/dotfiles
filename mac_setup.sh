# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
### Mac Configuration ###

# Finder Show All Files
defaults write com.apple.Finder AppleShowAllFiles true
killall Finder

# Disable the sound effects on boot
sudo nvram SystemAudioVolume=" "



### User Tools ###

# Install Cask
git clone git@github.com:Homebrew/homebrew-cask.git /usr/local/Homebrew/Library/Taps/homebrew/

# Install Firefox
brew cask install firefox

### Development Tools ###

# Install Virtualbox
brew cask install virtualbox

# Install Vagrant
brew cask install vagrant

# Install Vagrant Manager
brew cask install vagrant-manager

# Intall wget
brew install wget


### Dev Install ###

# XCode Select Install
xcode-select --install

# Cocoapods Install
sudo gem install cocoapods

# Android SDK
brew install gradle
brew cask install android-sdk
touch ~/.android/repositories.cfg
sdkmanager --license
sdkmanager --update
sdkmanager "platform-tools" "platforms;android-28"

# Install Flutter
mkdir -p ~/SDK
cd ~/SDK
git clone https://github.com/flutter/flutter.git -b stable --depth 1
flutter
flutter doctor

# Install Nodejs
brew install nodejs

# Install Go
# install it via https://golang.org/dl/ 

# Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh


### Symlinks ###

