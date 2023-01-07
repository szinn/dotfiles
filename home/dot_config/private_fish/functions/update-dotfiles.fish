function update-dotfiles --description 'Update shell environment'
  chezmoi update -a

  brewup

  # if type -q asdf
  #   asdf update
  # end

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

  update-packages
  update-completions
end
