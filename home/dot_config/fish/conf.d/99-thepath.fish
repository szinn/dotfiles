function thepath --description 'Shorten given path with substitutions'
  set -l subs "$HOME:~"

  set -l the_path $argv
  for i in $subs
    set -l parts (string split ':' $i)
    set the_path (string replace $parts[1] $parts[2] $the_path) 
  end

  echo $the_path
end
