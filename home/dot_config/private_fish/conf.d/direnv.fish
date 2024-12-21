if type -q direnv
  if status --is-interactive
    direnv hook fish | source
  end
end
