function update-emacs --description="Update emacs"
    # With package-install-upgrade-built-in set, package-upgrade-all also tries to
    # upgrade built-ins whose ELPA version is already current, and errors on each.
    # Packages installed from ELPA are still upgraded with it off.
    emacs --batch -l ~/.emacs.d/lisp/init-elpa.el --eval '(let ((package-install-upgrade-built-in nil)) (package-upgrade-all) (package-vc-upgrade-all))'
end
