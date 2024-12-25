function update --description="Update everything"
  brewup
  if type -q kubectl-krew
    kubectl-krew update
    kubectl-krew upgrade
  end
  if type -q fisher
    fisher update
  end
end
