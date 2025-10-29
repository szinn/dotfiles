function gcb --description="Create a new branch from main"
    git checkout main && git pull && git checkout -b $argv
end
