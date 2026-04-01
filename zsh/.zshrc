# =============================================================================
# ZSH CONFIGURATION
# =============================================================================

# -----------------------------------------------------------------------------
# CORE OPTIONS
# -----------------------------------------------------------------------------

setopt INTERACTIVE_COMMENTS
setopt NO_BEEP
setopt NO_LIST_BEEP
setopt AUTO_CD
setopt CORRECT
setopt EXTENDED_GLOB
setopt NO_CLOBBER

# -----------------------------------------------------------------------------
# HISTORY
# -----------------------------------------------------------------------------

export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=50000
export SAVEHIST=50000

setopt EXTENDED_HISTORY
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY

# -----------------------------------------------------------------------------
# COMPLETION
# -----------------------------------------------------------------------------

autoload -Uz compinit

if [[ -n "$HOME/.zcompdump"(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
zstyle ':completion:*:warnings' format '%F{red}No matches found%f'
zstyle ':completion:*' group-name ''
zstyle ':completion::complete:*' gain-privileges 1
zstyle ':completion:*:default' list-colors 'ow=01;34:tw=01;34:di=01;34'

# -----------------------------------------------------------------------------
# PLUGINS
# -----------------------------------------------------------------------------

# Portable Zsh Autosuggestions
if [[ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
elif [[ -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_AUTOSUGGEST_USE_ASYNC=1

# Portable Zsh Syntax Highlighting
if [[ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [[ -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# -----------------------------------------------------------------------------
# TOOL INTEGRATIONS (Auto-updating Cache)
# -----------------------------------------------------------------------------

load_cached_init() {
  local cmd="$1"
  local cache_file="$HOME/.cache/${cmd}_init.zsh"
  
  # Only proceed if the command is actually installed
  if command -v "$cmd" >/dev/null; then
    local bin_path="$(command -v "$cmd")"
    
    # Generate cache if it doesn't exist OR if the binary is newer than the cache
    if [[ ! -f "$cache_file" ]] || [[ "$bin_path" -nt "$cache_file" ]]; then
      "$cmd" init zsh > "$cache_file"
    fi
    source "$cache_file"
  fi
}

load_cached_init atuin
load_cached_init zoxide
load_cached_init starship

# FZF Environment Variables
export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --exclude .git'
export FZF_CTRL_T_OPTS="--preview 'bat --style=numbers --color=always --line-range :500 {}'"

eval "$(fzf --zsh)"

# -----------------------------------------------------------------------------
# ENVIRONMENT
# -----------------------------------------------------------------------------

export LS_COLORS="di=38;5;117:ow=1;34:"

# Deduplicated PATH
typeset -U path
path=("$HOME/.local/bin" $path)
export PATH

export EZA_CONFIG_DIR="$HOME/.config/eza"
export EZA_THEME="theme"
export BAT_THEME="Catppuccin Mocha"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export EDITOR="nvim"
export VISUAL="nvim"
export LESS="-R -i -F -X"

# -----------------------------------------------------------------------------
# ALIASES
# -----------------------------------------------------------------------------

# Core Aliases
alias cat='bat'
alias grep='grep --color=auto'
alias diff='diff --color=auto'
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -iv'
alias mkdir='mkdir -pv'

# Navigation Shortcuts
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'
alias -- -='cd -'

# Eza (ls replacement)
alias ls='eza --icons=always --group-directories-first'
alias ll='eza --icons=always --group-directories-first --long --header --git'
alias la='eza --icons=always --group-directories-first --long --header --grid --git --all'
alias lt='eza --icons=always --group-directories-first --tree --level=2 --ignore-glob=".git|node_modules|.DS_Store"'
alias lt3='eza --icons=always --group-directories-first --tree --level=3 --ignore-glob=".git|node_modules|.DS_Store"'
alias lt4='eza --icons=always --group-directories-first --tree --level=4 --ignore-glob=".git|node_modules|.DS_Store"'
alias lS='eza --icons=always --group-directories-first --long --sort=size'
alias ld='eza --icons=always --group-directories-first --long --sort=modified'

# System
alias q='exit'
alias c='clear'
alias h='history'
alias j='jobs -l'
alias df='df -h'
alias du='du -h'
alias free='free -h'

alias zshrc='$EDITOR ~/.zshrc'
alias reload='source ~/.zshrc && echo "✓ zshrc reloaded"'

# Custom tool aliases
alias nf="nvim \$(fzf --preview 'bat --style=numbers --color=always --line-range :500 {}')"

# Git
alias g='git'
alias gs='git status -sb'
alias ga='git add'
alias gaa='git add --all'
alias gc='git commit -v'
alias gcm='git commit -m'
alias gp='git push'
alias gpl='git pull --rebase'
alias gd='git diff'
alias gds='git diff --staged'
alias gl='git log --oneline --graph --decorate --all'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gb='git branch -vv'

# Modern CLI Tools
alias lg='lazygit'

# Archive extraction (Requires: dnf install atool)
alias extract='aunpack'

# -----------------------------------------------------------------------------
# FUNCTIONS
# -----------------------------------------------------------------------------

mkcd() {
  mkdir -p "$1" && cd "$1"
}

up() {
  local d=""
  for ((i=1; i<=${1:-1}; i++)); do d="../$d"; done
  cd "$d" || return
}

fcd() {
  local dir
  dir=$(fd --type d --hidden --exclude .git | fzf --preview 'eza --tree --level=2 --icons {}')
  [ -n "$dir" ] && cd "$dir"
}

port() {
  lsof -i :"$1"
}

# =============================================================================
# END
# =============================================================================

# Load unversioned local secrets (API keys, work tokens) if the file exists
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
