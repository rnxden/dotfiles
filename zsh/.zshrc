## Variables

# Add local bin directory to PATH
export PATH="$HOME/.local/bin:$PATH"

# Set default programs
export EDITOR='nvim'
#export TERMINAL=
#export BROWSER=

# Force truecolor support for programs that support it
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
alias gr="git restore"
alias gs="git status --short --branch"
alias gsw="git switch"

# Other shortcuts
alias d="docker"
alias k="kubectl"

## Prompt
PS1="%F{magenta}%~ %f$ "

# Make command line navigation behave like emacs
WORDCHARS="${WORDCHARS//[\/.-]}"
bindkey -e

## Misc

# Source local .zshrc
if [[ -e "$HOME/.zshrc.local" ]]; then
  source "$HOME/.zshrc.local"
fi

# Disable CTRL+S hanging
stty -ixon
