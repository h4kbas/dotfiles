
### SDK Path ###

# OpenJDK compile args 
export CPPFLAGS="-I/usr/local/opt/openjdk/include"

# Android paths
export GRADLE_HOME=/usr/local/opt/gradle
export ANDROID_SDK_ROOT=/usr/local/share/android-sdk
export ANDROID_HOME=/usr/local/share/android-sdk
export PATH=$ANDROID_HOME/tools:$PATH
export PATH=$ANDROID_HOME/platform-tools:$PATH

# Flutter path
export PATH="$PATH:$HOME/SDK/flutter/bin:$PATH"

# Go path
export PATH=$PATH:/usr/local/go/bin
export GOPATH=$HOME/Workspace

# Rust path
export PATH="$HOME/.cargo/bin:$PATH"

