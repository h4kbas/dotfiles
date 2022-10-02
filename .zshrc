# Auth path
export PATH="/usr/local/opt/python@3.7/bin:$PATH"
# Config
export PROMPT_DIRTRIM=2

# Custom alias
alias noveupsshfs='sshfs root@78.141.193.132:/home ~/Noveup -o defer_permissions -o volname=Noveup'
alias vim='/usr/local/bin/nvim'

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



# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000


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

if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

  autoload -Uz compinit
  compinit
fi

# Prompt config
parse_git_branch() {
    git_status="$(git status 2> /dev/null)"
    pattern="On branch ([^[:space:]]*)"
    if [[ ! ${git_status} =~ "(working (tree|directory) clean)" ]]; then
        state="*"
    fi
    if [[ ${git_status} =~ ${pattern} ]]; then
      branch=${match[1]}
      branch_cut=${branch:0:35}
      if (( ${#branch} > ${#branch_cut} )); then
          echo "(${branch_cut}?${state})"
      else
          echo "(${branch}${state})"
      fi
    fi
}

setopt PROMPT_SUBST
PROMPT='%{%F{yellow}%}%9c%{%F{none}%} $(parse_git_branch)$ '
