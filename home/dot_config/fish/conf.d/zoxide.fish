# zoxide setup
# Requires `brew install zoxide`
if type -q zoxide
    if status --is-interactive
        zoxide init fish | source
    end
end
