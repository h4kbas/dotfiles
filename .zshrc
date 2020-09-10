
# Config
export PROMPT_DIRTRIM=2

# Alias metworking tools
alias ip='dig +short myip.opendns.com @resolver1.opendns.com'
alias localip='ipconfig getifaddr en0'
alias ips="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"
alias hhosts='sudo vim /etc/hosts'

# Alias applications
alias vim='/usr/local/bin/nvim'

# Enable colors 
autoload -U colors && colors

# Vim mode
bindkey -v

bindkey '^P' up-history
bindkey '^N' down-history
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char
bindkey '^w' backward-kill-word
bindkey '^r' history-incremental-search-backward

precmd() { RPROMPT="" }
function zle-line-init zle-keymap-select {
   VIM_PROMPT="%{$fg_bold[yellow]%} [% INSERT]%  %{$reset_color%}"
   RPS1="${${KEYMAP/vicmd/[% NORMAL]%}/(main|viins)/$VIM_PROMPT}"
   zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select

export KEYTIMEOUT=1
