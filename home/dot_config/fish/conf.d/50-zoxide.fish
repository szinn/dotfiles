# zoxide setup
# Requires `brew install zoxide`
if type -q zoxide
    if status --is-interactive
        set -gx _ZO_EXCLUDE_DIRS "$HOME:$HOME/Library/*:$HOME/Music/*:/Applications/*:/opt/*"
        zoxide init fish | source
    end
end
