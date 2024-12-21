# kubectl setup
# Requires `brew install kubectl`
if type -q kubectl
  if status --is-interactive
    alias k kubectl
  end
end
