function update-emacs --description="Update emacs"
    emacs --batch -l ~/.emacs.d/lisp/init-elpa.el --eval '(progn (package-upgrade-all) (package-vc-upgrade-all))'
end
