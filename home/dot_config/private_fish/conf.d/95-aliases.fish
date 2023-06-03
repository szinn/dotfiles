if command -sq python
  alias pip="python -m pip"
end

if command -sq python3
  alias pip3="python3 -m pip"
end

if command -sq ssh-ident
  alias ssh=(which ssh-ident)
  alias rsync='BINARY_SSH=rsync /path/to/ssh-ident'
end

if command -sq ~/.config/tmux/plugins/t-smart-tmux-session-manager/bin/t
  alias t ~/.config/tmux/plugins/t-smart-tmux-session-manager/bin/t
end

if command -sq tmux
  alias ns "tmux new -s (basename $PWD)"
end
