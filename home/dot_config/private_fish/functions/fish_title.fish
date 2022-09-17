# Change the terminal title automatically based on current process / working-directory
#
# The main improvement over the default 'fish_title' behavior
# is that I use the name of the current git repo, if any, as
# opposed to the raw working-directory
function fish_title
    set -f command (echo $_)

    if test $command = "fish"
        # we are sitting at the fish prompt
        if git rev-parse --git-dir > /dev/null 2>&1
          set -f git_dir (git rev-parse --git-dir)
          if test $git_dir = ".git"
            set -f git_repo (basename (pwd))
          else
            set -f git_repo (basename (dirname $git_dir))
          end
          set -l current_git_branch (git -C "$1" branch | sed  '/^\*/!d;s/\* //')
          echo "$(thepath $PWD) ($git_repo: $current_git_branch)"
        else
          echo (pwd)
        end
    else
        # we are busy running some non-fish command, so use the command name
        echo $command
    end
end
