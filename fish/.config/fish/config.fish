if status is-interactive
    # Commands to run in interactive sessions can go here
end

alias cls="clear"
alias py="python3"
alias vim="nvim"
# alias cd="z"

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


function gcap
    git add . && git commit -m "$argv" && git push
end

set -Ux fish_user_paths $fish_user_paths $HOME/go/bin
set -x PATH $PATH /usr/local/go/bin $GOPATH/bin

