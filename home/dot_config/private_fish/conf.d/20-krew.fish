set -gx KREW_ROOT_DIR $HOME/.krew

if type -q krew
  fish_add_path "$KREW_ROOT_DIR/bin"
else
  set -e KREW_ROOT_DIR
end
