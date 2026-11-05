# Fisher installs plugins under $fisher_path instead of ~/.config/fish, so
# conf.d and functions hold only chezmoi-managed files. The plugin list stays
# in ~/.config/fish/fish_plugins. Sorts after 00-env.fish, which sets
# XDG_DATA_HOME.
set -q XDG_DATA_HOME[1]; or set -l XDG_DATA_HOME $HOME/.local/share
set -g fisher_path $XDG_DATA_HOME/fisher

contains -- $fisher_path/functions $fish_function_path
or set fish_function_path $fish_function_path[1] $fisher_path/functions $fish_function_path[2..-1]

contains -- $fisher_path/completions $fish_complete_path
or set fish_complete_path $fish_complete_path[1] $fisher_path/completions $fish_complete_path[2..-1]

for file in $fisher_path/conf.d/*.fish
    source $file
end
