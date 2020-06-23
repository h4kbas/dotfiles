
# Config
export PROMPT_DIRTRIM=2

# Alias metworking tools
alias ip='dig +short myip.opendns.com @resolver1.opendns.com'
alias localip='ipconfig getifaddr en0'
alias ips="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"
alias hhosts='sudo vim /etc/hosts'

# Alias applications
alias vim='/usr/local/Cellar/vim/8.2.0800/bin/vim'

# Enable colors 
autoload -U colors && colors

### SDK Path ###

# OpenJDK path
# export PATH="/usr/local/opt/openjdk/bin:$PATH"
export CPPFLAGS="-I/usr/local/opt/openjdk/include"

# Android paths
export GRADLE_HOME=/usr/local/opt/gradle
export ANDROID_SDK_ROOT=/usr/local/share/android-sdk
export ANDROID_HOME=/usr/local/share/android-sdk
export PATH=$ANDROID_HOME/tools:$PATH
export PATH=$ANDROID_HOME/platform-tools:$PATH
#export PATH=$ANDROID_HOME/build-tools/$(ls -tr $ANDROID_HOME/build-tools/ | tail -1):$PATH

# Flutter path
export PATH="$PATH:$HOME/SDK/flutter/bin:$PATH"

