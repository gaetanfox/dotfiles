# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(zsh-syntax-highlighting zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

# User configuration

alias em='emacsclient -c -a ""'
alias et='emacsclient -t -a ""'
alias e='/opt/homebrew/bin/emacsclient -n -c -a ""'

alias cls="clear"
alias py="uv run "
alias python="uv "
alias v="nvim"
alias cd="z"
alias gs="git status"

alias glow="glow -t "


alias ta="tmux attach-session -t"
alias tl="tmux list-sessions"

tda() {
  tmux new-session -s "$(basename $(pwd))"
}
# eza (better 'ls')
alias l="eza --icons"
alias ls="eza --icons"
alias ll="eza -lg --icons"
alias la="eza -lag --icons"
alias lt="eza -lg --icons"
alias lt1="eza -lTg --level=1 --icons"
alias lt2="eza -lTg --level=2 --icons"
alias lt3="eza -lTg --level=3 --icons"
alias lta="eza -lag --icons"
alias lta1="eza -lTag --level=1 --icons"
alias lta2="eza -lTag --level=2 --icons"
alias lta3="eza -lTag --level=3 --icons"

alias k="kubectl"

function sesh-sessions() {
  {
    exec </dev/tty
    exec <&1
    local session
    session=$(sesh list -t -c | fzf --height 40% --reverse --border-label ' sesh ' --border --prompt '⚡  ')
    zle reset-prompt > /dev/null 2>&1 || true
    [[ -z "$session" ]] && return
    sesh connect $session
  }
}

zle     -N             sesh-sessions

# Keybinding for popup_sesh
bindkey '^S' sesh-sessions

# Define a widget that runs the command
function run_tmux_sessionizer() {
  ~/./tmux-sessionizer
}

# Register the widget with zle
zle -N run_tmux_sessionizer

# Bind Ctrl+F to the run_tmux_sessionizer widget
bindkey '^F' run_tmux_sessionizer

# Function: gcap
gcap() {
    git add . && git commit -m "$1" && git push
}

# Set PATH environment variables
export PATH="$PATH:$HOME/go/bin:/usr/local/go/bin:$GOPATH/bin"
export PATH="$PATH:/Users/gaetanfox/.local/bin" # Added by pipx on 2024-11-24 10:59:05
export PATH="$PATH:/opt/homebrew/bin:$PATH" # Added by pipx on 2024-11-24 10:59:05

fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src
# zoxide initialization for Zsh
eval "$(zoxide init zsh)"
# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

alias pip="uv pip"
export UV_AUTO_VENV=1
export PATH="/opt/homebrew/opt/postgresql@17/bin:$PATH"

# pnpm
export PNPM_HOME="/Users/gaetanfox/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

PATH=~/.console-ninja/.bin:$PATH
# Added by Windsurf
export PATH="/Users/gaetanfox/.codeium/windsurf/bin:$PATH"

# Task Master aliases added on 6/25/2025
alias tm='task-master'
alias taskmaster='task-master'

fpath+=~/.zfunc; autoload -Uz compinit; compinit

zstyle ':completion:*' menu select

# bun
export BUN_INSTALL="$HOME/Library/Application Support/reflex/bun"
export PATH="$BUN_INSTALL/bin:$PATH"
