# atuin setup
# Requires `brew install atuin`
if type -q atuin
  if status --is-interactive
    atuin init fish --disable-up-arrow | source
  end
end
