set -gx KREW_ROOT_DIR $HOME/.krew

if type -q krew
  set -l krew_bin_path "$KREW_ROOT_DIR/bin"

  contains -- $krew_bin_path $PATH
    or set -gx PATH $PATH $krew_bin_path
else
  set -e KREW_ROOT_DIR
end
