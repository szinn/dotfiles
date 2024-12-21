# eza setup
# Requires `brew install eza`
if type -q eza
  if status --is-interactive
    alias ls 'eza --group --icons'
    alias ll 'eza --group --icons -l'
    alias la 'eza --group --icons -a'
    alias lt 'eza --group --icons --tree'
    alias lla 'eza --group --icons -la'
  end
end
