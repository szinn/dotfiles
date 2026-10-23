;;; early-init.el --- Emacs 27+ pre-initialisation config  -*- lexical-binding: t; -*-

;;; Commentary:

;; Emacs 27+ loads this file before (normally) calling
;; `package-initialize'.  We use this file to suppress that automatic
;; behaviour so that startup is consistent across Emacs versions.

;;; Code:

(setq package-enable-at-startup nil)

;; GCC's Darwin driver guesses the macOS version from the kernel version
;; (Darwin 27 -> "18.0"), which is wrong since Apple's jump to macOS 26
;; and makes clang reject the native-comp build.  Pass the real version.
(when (and (eq system-type 'darwin)
           (featurep 'native-compile))
  (with-eval-after-load 'comp
    (let ((ver (string-trim (shell-command-to-string "sw_vers -productVersion"))))
      (when (string-match "\\`[0-9]+" ver)
        (add-to-list 'native-comp-driver-options
                     (format "-mmacosx-version-min=%s.0" (match-string 0 ver)))))))

;; So we can detect this having been loaded
(provide 'early-init)

;;; early-init.el ends here
