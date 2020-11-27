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
git clone https://github.com/flutter/flutter.git -b stable --depth 1 --no-single-branch
flutter
flutter doctor

# Install Nodejs
brew install nodejs

# Install Go
# install it via https://golang.org/dl/ 

# Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

