function update --description="Update everything"
  brewup
  if type -q kubectl-krew
    kubectl-krew update
    kubectl-krew upgrade
  end
  if type -q fisher
    fisher update
  end

  if type -q helm
    for plugin in (helm plugin list | grep -v "VERSION" | awk '{print $1}')
      helm plugin update $plugin
    end
  end
end
