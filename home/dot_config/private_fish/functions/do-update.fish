function do-update --description 'Update shell environment'
  chezmoi apply

  if type -q brew
    brew update
    brew upgrade
    brew cleanup
    brew doctor
  end

  if type -q omf
    omf update
  end
  if type -q fisher
    fisher update
  end

  if type -q rustup
    rustup update
  end

  if type -q krew
    krew upgrade
  end

  update_completions
end
