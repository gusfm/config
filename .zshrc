# Set up the prompt
PROMPT="%B%F{blue}%~%f%b %% "

setopt histignorealldups nosharehistory

# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

# Keep 10k lines of history within the shell and save it to ~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
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
alias vim='vim -X'
alias gvim='gvim -X'

# Search history when pressing Up or Down. The `key` array these bindings used
# to be guarded on is Debian zsh-newuser-install boilerplate that Arch never
# populates, so bind through terminfo instead, with raw fallbacks covering both
# normal and application cursor mode.
zmodload zsh/terminfo
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
for k in "${terminfo[kcuu1]}" '^[[A' '^[OA'; do
    [[ -n "$k" ]] && bindkey "$k" up-line-or-beginning-search
done
for k in "${terminfo[kcud1]}" '^[[B' '^[OB'; do
    [[ -n "$k" ]] && bindkey "$k" down-line-or-beginning-search
done
unset k

# Use the socket-activated user ssh-agent (systemctl --user enable ssh-agent.socket).
# Test for a live socket rather than an unset variable: the Hyprland session
# exports SSH_AUTH_SOCK from ~/.config/environment.d, so a stale or unexpanded
# value there would otherwise suppress this.
if [[ ! -S "$SSH_AUTH_SOCK" && -S "$XDG_RUNTIME_DIR/ssh-agent.socket" ]]; then
    export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
fi

# Omarchy's /etc/profile.d/omarchy.sh already appends ~/.local/bin and the mise
# shims for login shells, and -U keeps nested shells from stacking duplicates.
typeset -U path PATH
path+=("$HOME/bin")
export PATH
