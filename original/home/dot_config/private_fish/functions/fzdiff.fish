function fzdiff --description "fzf applied to git diff"
  set -l preview "git diff $argv --color=always -- {-1}"
  git diff $argv --name-only | fzf -m --ansi --preview $preview
end
