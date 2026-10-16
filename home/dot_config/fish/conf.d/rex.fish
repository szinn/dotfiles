if type -q rex
    if status --is-interactive
        eval (rex completion fish)
    end
end
