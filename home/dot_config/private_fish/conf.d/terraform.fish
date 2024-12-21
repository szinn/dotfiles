# kubectl setup
# Requires `brew install terraform`
if type -q terraform
  if status --is-interactive
    alias tf terraform
  end
end
