function gh --description="Wrap github gh"
    if test -d .git
        $HOMEBREW_PREFIX/bin/gh $argv
    else if test -d .jj
        GIT_DIR=$PWD/.jj/repo/store/git $HOMEBREW_PREFIX/bin/gh $argv
    else
        $HOMEBREW_PREFIX/bin/gh $argv
    end
end
