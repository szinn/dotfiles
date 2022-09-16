function update --description 'Update shell environment'
  chezmoi apply

  if type -q brew
    brew update
    brew upgrade
    brew cleanup
    brew doctor
  end

  if type -q aqua
    aqua i
  end

  omf update
  fisher update

  if type -q rustup
    rustup update
  end

  if type -q kubectl-krew
    kubectl-krew upgrade
  end

  update_completions
end
