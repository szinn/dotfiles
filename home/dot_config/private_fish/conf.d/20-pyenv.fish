if test -d $HOME/.pyenv
  set -Ux PYENV_ROOT $HOME/.pyenv
  pyenv init - | source
end

