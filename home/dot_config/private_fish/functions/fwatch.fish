function fwatch --description 'watch with fish alias support'
  if count $argv > /dev/null
    command watch -x (which fish) -c "$argv"
  end
end
