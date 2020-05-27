

export PROMPT_DIRTRIM=2

# Alias directories
alias w="cd ~/Workspace"

# Alias metworking tools
alias ip='dig +short myip.opendns.com @resolver1.opendns.com'
alias localip='ipconfig getifaddr en0'
alias ips="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"
alias hhosts='sudo nano /etc/hosts'

# Alias applications
alias vim='/usr/local/Cellar/vim/8.2.0800/bin/vim'
