# Aliases
abbr ap ansible-playbook
abbr apb ansible-playbook --ask-become
abbr cm chezmoi
abbr cmd chezmoi diff --no-pager
abbr gitp git push
abbr m less
abbr opw 'eval (op signin)'
abbr tf terraform
abbr x exit

if type -q eza
    set -gx EZA_COLORS "da=1;34:gm=1;34"

    alias l eza
    alias la 'eza --long --all --group --header --binary --links --inode --blocks'
    alias ld 'eza --long --all --group --header --list-dirs'
    alias ll 'eza --long --all --group --header'
    alias lt 'eza --long --all --group --header --tree --level'
end
