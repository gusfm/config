# Set up the prompt
PROMPT="%B%F{blue}%~%f%b %% "

setopt histignorealldups nosharehistory

# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

fpath=(~/.zsh $fpath)

# Use modern completion system
autoload -Uz compinit
compinit

# Completion menu
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
# ls colors
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''

# Aliases
alias gitk='gitk --max-count=500'
alias grep='grep --color=auto'
alias ls='ls --color=auto'

# Use nvim as man-page viewer
export MANPAGER="nvim -c 'set ft=man laststatus=0' -"

# Search history when pressing Up or Down
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down
