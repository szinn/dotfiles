function install-haskell --description="Install latest haskell tools"
    mkdir -p $HOME/.cabal/bin
    mkdir -p $HOME/.ghcup/bin

    ghcup install ghc latest
    ghcup install cabal latest
    ghcup install hls latest

    ghcup set ghc latest
    ghcup set cabal latest
    ghcup set hls latest
end
