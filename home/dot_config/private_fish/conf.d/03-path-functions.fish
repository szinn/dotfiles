function remove_path
    if set -l index (contains -i $argv[1] $PATH)
        set --erase --universal fish_user_paths[$index]
    end
end

function update_path
    if test -d $argv[1]
        fish_add_path -m $argv[1]
    else
        remove_path $argv[1]
    end
end
