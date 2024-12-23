set -gx HOMEBREW_NO_ANALYTICS 1
# Specify where the brew bundle input file lives
set -gx HOMEBREW_BUNDLE_FILE $XDG_CONFIG_HOME/homebrew/brewfile
# Automatically remove quarantine flag from casks
set -gx HOMEBREW_CASK_OPTS --no-quarantine
# More frequent package updates
set -gx HOMEBREW_AUTO_UPDATE_SECS 86400

eval (/opt/homebrew/bin/brew shellenv)

update_path $HOMEBREW_PREFIX/bin
update_path $HOMEBREW_PREFIX/opt/postgresql@17/bin
update_path $HOMEBREW_PREFIX/opt/curl/bin
update_path $HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin
update_path $HOMEBREW_PREFIX/opt/gnu-sed/libexec/gnubin
update_path $HOMEBREW_PREFIX/opt/gawk/libexec/gnubin
update_path $HOMEBREW_PREFIX/opt/findutils/libexec/gnubin
