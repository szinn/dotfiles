if type -q flux
    if status --is-interactive
        eval (flux completion fish)
    end
end
