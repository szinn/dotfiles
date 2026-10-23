;;; init-jj.el --- Jujutsu (jj) VCS support -*- lexical-binding: t -*-
;;; Commentary:

;; jj-mode is not on MELPA, so install it straight from GitHub.

;;; Code:

(unless (package-installed-p 'jj-mode)
  (ignore-errors
    (package-vc-install "https://github.com/bolivier/jj-mode.el")))

(when (package-installed-p 'jj-mode)
  (autoload 'jj-log "jj-mode" nil t)
  (global-set-key (kbd "C-x j") 'jj-log))

(provide 'init-jj)
;;; init-jj.el ends here
