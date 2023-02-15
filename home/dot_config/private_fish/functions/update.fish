function update --description "Update chezmoi environment"
  if test -z $argv[1]
    QUICK_APPLY='y' chezmoi apply
  else
    if test $argv[1] = "-f"
      chezmoi update -a
    else
      QUICK_APPLY='y' chezmoi apply
    end
  end
end
