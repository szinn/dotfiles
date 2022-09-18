set HOMEBREW_PREFIX (brew --prefix)7

if test -d "$HOMEBREW_PREFIX/share/fish/completions"
  set -gx fish_complete_path $fish_complete_path "$HOMEBREW_PREFIX/share/fish/completions"
end

if test -d "$HOMEBREW_PREFIX/share/fish/vendor_completions.d"
  set -gx fish_complete_path $fish_complete_path "$HOMEBREW_PREFIX/share/fish/vendor_completions.d"
end
