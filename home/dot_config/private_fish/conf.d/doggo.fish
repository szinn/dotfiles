# doggo setup
# Requires `brew install doggo`
if type -q doggo
  if status --is-interactive
    alias dig doggo
  end
end
