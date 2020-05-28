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

