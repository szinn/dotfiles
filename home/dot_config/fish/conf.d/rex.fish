# Records the command running in each Rex terminal, for `rx --export`.
# Rex reports only a process's name, so without this `rx --export` loses
# arguments, abbreviations and shell syntax. The command about to run is
# written to ${XDG_STATE_HOME:-~/.local/state}/rx/commands/<block id> and
# deleted when it finishes. The builtin `test` guards keep these hooks from
# forking rm and mkdir on every command.
if status --is-interactive; and set -q REX_BLOCK
    set -g __rx_commands_dir $XDG_STATE_HOME
    test -n "$__rx_commands_dir"; or set __rx_commands_dir $HOME/.local/state
    set __rx_commands_dir $__rx_commands_dir/rx/commands
    set -g __rx_command_file $__rx_commands_dir/$REX_BLOCK

    function __rx_clear_command --on-event fish_postexec --on-event fish_exit
        test -e $__rx_command_file; and rm -f -- $__rx_command_file
        return 0
    end

    function __rx_record_command --on-event fish_preexec
        __rx_clear_command
        # Like fish's private-command history rule: a command typed with a
        # leading space is deliberately left out of exported definitions too.
        string match -q -- ' *' $argv[1]; and return 0
        test -d $__rx_commands_dir; or mkdir -p -- $__rx_commands_dir; or return
        printf '%s\n' $argv[1] >$__rx_command_file
    end
end

abbr --add -- rex-kill 'rex session kill (rex session ls | fzf | awk \'{print $2}\')'
