# --- UI & APPEARANCE ---
autoload -U colors && colors
setopt PROMPT_SUBST

# Matches WezTerm: yellow=Epsilon, magenta=Iota
parse_git_branch() {
    local git_status="$(git status 2> /dev/null)"
    local pattern="On branch ([^[:space:]]*)"
    local state=""
    if [[ ! ${git_status} =~ "working (tree|directory) clean" ]]; then
        state="*"
    fi
    if [[ ${git_status} =~ ${pattern} ]]; then
      local branch=${match[1]}
      local branch_cut=${branch:0:35}
      if (( ${#branch} > ${#branch_cut} )); then
          echo "%F{magenta}(${branch_cut}?${state})%f"
      else
          echo "%F{magenta}(${branch}${state})%f"
      fi
    fi
}

export PROMPT_DIRTRIM=2
PROMPT='%F{yellow}%9c%f $(parse_git_branch)$ '

# --- ALIASES ---
alias vim='/opt/homebrew/bin/nvim'
alias c='clear'
# Networking
alias ip='dig +short myip.opendns.com @resolver1.opendns.com'
alias localip='ipconfig getifaddr en0'
alias ips="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"
alias hhosts='sudo vim /etc/hosts'

# Git
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

# File Listing
alias ls='ls -G'
alias ll='ls -lhG'
alias la='ls -ahG'

# --- COMPLETIONS & BEHAVIOR ---
set completion-ignore-case on
set show-all-if-ambiguous on
set page-completions off
set completion-query-items 200
set match-hidden-files off
set skip-completed-text on

if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
  autoload -Uz compinit
  compinit
fi

# Visual tab-completion menu
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu select

# --- EXTERNAL SOURCES ---
# Bun Completions
[ -s "/Users/huseyinakbas/.bun/_bun" ] && source "/Users/huseyinakbas/.bun/_bun"

# Private stuff
[ -f ~/.zsh_private ] && source ~/.zsh_private
