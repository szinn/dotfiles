set -l home_bin_path "$HOME/.local/bin"

contains -- $home_bin_path $PATH
  or set -gx PATH $home_bin_path $PATH
set -l home_bin_path "$HOME/bin"

contains -- $home_bin_path $PATH
  or set -gx PATH $home_bin_path $PATH
