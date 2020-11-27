
# Config
export PROMPT_DIRTRIM=2

# Custom alias
alias noveupsshfs='sshfs root@78.141.193.132:/home ~/Noveup -o defer_permissions -o volname=Noveup'

# Alias metworking tools
alias ip='dig +short myip.opendns.com @resolver1.opendns.com'
alias localip='ipconfig getifaddr en0'
alias ips="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"
alias hhosts='sudo vim /etc/hosts'
alias c='clear'

# Git aliases
git config --global alias.s status
git config --global alias.r 'reset HEAD --'
git config --global alias.last 'log -1 HEAD'
git config --global alias.a 'add .'
git config --global alias.c 'commit -m'
git config --global alias.co checkout
git config --global alias.cb 'checkout -b' 
git config --global alias.p 'push origin' 
git config --global alias.pl 'pull origin' 

alias gs='git status'
alias gu='git reset HEAD --'
alias gl='git last -1 HEAD'
alias ga='git add .'
alias gc='git commit -m'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gp='git push'
alias gpl='git pull'
alias gpsh='git push origin'
alias gpull='git pull origin'
alias gm='git merge'


# Allow UTF-8 input and output, instead of showing stuff like $'\0123\0456'
set input-meta on
set output-meta on
set convert-meta off

# Enable colors 
autoload -U colors && colors

# Make Tab autocomplete regardless of filename case
set completion-ignore-case on

# List all matches in case multiple possible completions are possible
set show-all-if-ambiguous on

# Show all autocomplete results at once
set page-completions off

# If there are more than 200 possible completions for a word, ask to show them all
set completion-query-items 200

# Do not autocomplete hidden files unless the pattern explicitly begins with a dot
set match-hidden-files off

# Be more intelligent when autocompleting by also looking at the text after
set skip-completed-text on
