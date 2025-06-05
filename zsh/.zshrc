## Variables

# Set XDG variables (not required, but useful for scripts)
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"   # stores data files
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"    # stores config files
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}" # stores persistent state files
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"       # stores non-essential cache files

# Add local bin directory to PATH
export PATH="$HOME/.local/bin:$PATH"

# Set default programs
export EDITOR='nvim'
export MANPAGER='nvim +Man!'
#export TERMINAL=
#export BROWSER=

# Enable truecolor support for programs that support it
export COLORTERM=truecolor

## Plugin Manager

# Bootstrap zimfw plugin manager
ZIM_HOME="$HOME/.zim"
ZIM_CONFIG_FILE="$HOME/.zimrc"

if [[ ! -e "$ZIM_HOME/zimfw.zsh" ]]; then
  curl -fsSL --create-dirs -o "$ZIM_HOME/zimfw.zsh" \
    https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
fi

# Install missing plugins
if [[ ! "$ZIM_HOME/init.zsh" -nt "$ZIM_CONFIG_FILE" ]]; then
  source "$ZIM_HOME/zimfw.zsh" init
fi

# Initialize zimfw
source "${ZIM_HOME}/init.zsh"

## Options

HISTFILE="$HOME/.zhistory"
HISTSIZE=10000 # maximum amount of history saved in a shell session
SAVEHIST=10000 # maximum amount of history saved to disk

# Share history between multiple concurrent shell sessions
setopt APPEND_HISTORY     # append to history file instead of overwriting it
setopt INC_APPEND_HISTORY # constantly append to history file instead of only at shell exit
setopt SHARE_HISTORY      # constantly import from history file

# Remove duplicates from command history
setopt HIST_IGNORE_DUPS     # don't save consecutive duplicate commands to the history list
setopt HIST_IGNORE_ALL_DUPS # don't save any duplicate commands to the history list
setopt HIST_SAVE_NO_DUPS    # don't write any duplicate commands to the history file
setopt HIST_FIND_NO_DUPS    # don't find any duplicate commands when searching through command history

setopt HIST_IGNORE_SPACE    # don't save commands starting with a space to the history list

## Completion

autoload -U compinit && compinit -d "$HOME/.zcompdump"

zstyle ':completion:*' menu select # enable completion menu
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' # allow case insensitive matching
zstyle ':completion:*:warnings' format '%F{red}no matches for:%f %d' # improve error message
eval "$(dircolors)" && zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS} # colorize matches

## Aliases

# Colorize command output
alias ls="ls --color=auto"
alias grep="grep --color=auto"
alias ip="ip --color=auto"

# Backtrack directories
alias ..="cd .."

# Zoxide shortcuts (cd alternative)
eval "$(zoxide init zsh)"

alias ze="zoxide edit"
alias zq="zoxide query"

# Eza shortcuts (ls alternative)
alias x="eza --icons --group-directories-first -g --git --time-style='+%m.%d.%y %H:%M'"

alias xa="x -a"
alias xal="x -al"
alias xl="x -l"

# Git shortcuts
alias g="git"
alias ga="git add"
alias gb="git branch"
alias gc="git commit"
alias gd="git diff"
alias gds="git diff --staged"
alias gf="git fetch"
alias gl="git log --all --graph --format=format:'%C(bold yellow)%h %C(reset)- %C(cyan)%an <%ae> %C(bold green)(%ar)%C(auto)%d%n%B'"
alias gp="git pull"
alias gps="git push"
alias gs="git status --short --branch"
alias gsw="git switch"

# Other shortcuts
alias d="docker"
alias k="kubectl"

## Prompt

precmd_prompt_info_time() {
  unset prompt_info_time

  local elapsed=$(( $EPOCHSECONDS - ${prompt_data_time:-$EPOCHSECONDS} ))
  if [[ $elapsed -gt 5 ]]; then
    local seconds=$(( elapsed % 60 ))
    local minutes=$(( elapsed / 60 % 60 ))
    local hours=$(( elapsed / 60 / 60 % 24 ))
    local days=$(( elapsed / 60 / 60 / 24 ))

    local human=""
    (( days > 0 )) && human+="${days}d"
    (( hours > 0 )) && human+="${hours}h"
    (( minutes > 0 )) && human+="${minutes}m"
    human+="${seconds}s"

    prompt_info_time="%F{blue}$human%f "
  fi

  unset prompt_data_time
}

precmd_prompt_info_cwd() {
  prompt_info_cwd="%F{8}" # bright black

  local dirnames=( ${(s:/:)$(print -P '%~')} )
  local dirnames_len=${#dirnames}

  if [[ "${dirnames[1]}" != "~" ]]; then
    prompt_info_cwd+="/"
  fi

  for (( i=1; i<$dirnames_len; i++ )); do
    local dirname=${dirnames[i]}
    local dirname_trunc=${dirname[1,1]}
    if [[ "$dirname_trunc" == "." ]]; then
      dirname_trunc=${dirname[1,2]}
    fi
    prompt_info_cwd+="$dirname_trunc/"
  done

  prompt_info_cwd+="%F{cyan}${dirnames[-1]}%f"
}

precmd_prompt_info_git() {
  unset prompt_info_git

  # Check for git repository
  if git rev-parse --git-dir &> /dev/null; then
    # Get branch or refname
    local ref
    ref=$(git symbolic-ref --short HEAD 2> /dev/null) \
      || ref=$(git describe --tags --exact-match HEAD 2> /dev/null) \
      || ref=$(git rev-parse --short HEAD 2> /dev/null) \
      || return 0

    prompt_info_git=" %F{red}@%F{magenta}$ref"

    # Check if branch is ahead/behind upstream
    local revs=( $(git rev-list --count --left-right '@{u}...HEAD' 2> /dev/null) )
    local behind=$revs[1]
    local ahead=$revs[2]

    if [[ behind -gt 0 ]]; then
      prompt_info_git+="%F{white}-%F{red}$behind"
    fi

    if [[ ahead -gt 0 ]]; then
      prompt_info_git+="%F{white}+%F{green}$ahead"
    fi

    # Check if branch is dirty
    if [[ ! -z "$(git status --porcelain -unormal 2> /dev/null)" ]]; then
      prompt_info_git+="%F{yellow}*"
    fi

    prompt_info_git+="%f"
  fi
}

preexec_prompt_info_time() {
  prompt_data_time=$EPOCHSECONDS
}

zmodload zsh/datetime # for $EPOCHSECONDS

precmd_prompt_info() {
  precmd_prompt_info_time
  precmd_prompt_info_cwd
  precmd_prompt_info_git
}
preexec_prompt_info() {
  preexec_prompt_info_time
}
precmd_functions+=( precmd_prompt_info )
preexec_functions+=( preexec_prompt_info )
setopt PROMPT_SUBST # expand variables in prompt

PROMPT="\$prompt_info_time\$prompt_info_cwd\$prompt_info_git "
PROMPT+="%(?:%F{green}:%F{red})❯%f "

# Make command line navigation behave like emacs
WORDCHARS="${WORDCHARS//[\/.-]}"
bindkey -e

## Plugins

# Configure zsh-autosuggestions
ZSH_AUTOSUGGEST_USE_ASYNC=1
ZSH_AUTOSUGGEST_STRATEGY=("completion")

#ZSH_AUTOSUGGEST_CLEAR_WIDGETS=()
ZSH_AUTOSUGGEST_ACCEPT_WIDGETS=()
ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS=()
ZSH_AUTOSUGGEST_EXECUTE_WIDGETS=()
ZSH_AUTOSUGGEST_IGNORE_WIDGETS=()

bindkey '^y' autosuggest-accept

## Misc

# Source local .zshrc
if [[ -e "$HOME/.zshrc.local" ]]; then
  source "$HOME/.zshrc.local"
fi

# Disable CTRL+S hanging
stty -ixon
