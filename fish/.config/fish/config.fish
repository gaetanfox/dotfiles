if status is-interactive
    # Commands to run in interactive sessions can go here
end

alias cls="clear"
alias py="python"
alias v="nvim"
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

alias k="kubectl"

function popup_sesh
    set selected_sesh (
 sesh list -i | gum filter --limit 1 --no-sort --fuzzy --placeholder 'Pick a sesh' --height 50 --prompt='⚡'
)
    if test -n "$selected_sesh"
        sesh connect "$selected_sesh"
    end
end

bind \cs popup_sesh


function gcap
    git add . && git commit -m "$argv" && git push
end

zoxide init fish | source
set -Ux fish_user_paths $fish_user_paths $HOME/go/bin
set -x PATH $PATH /usr/local/go/bin $GOPATH/bin


# Created by `pipx` on 2024-11-24 10:59:05
set PATH $PATH /Users/gaetanfox/.local/bin
