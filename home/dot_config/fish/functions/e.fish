function e --description 'emacsclient -nw, silently starting the Emacs daemon if needed'
    if not emacsclient --eval t >/dev/null 2>&1
        emacs --daemon >/dev/null 2>&1
    end
    emacsclient -nw $argv
end
