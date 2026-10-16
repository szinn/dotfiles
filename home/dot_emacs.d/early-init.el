;;; early-init.el --- Runs before package activation and the first frame  -*- lexical-binding: t; -*-

;;; Commentary:
;; Only startup-speed and UI settings belong here.  Everything else is in init.el.

;;; Code:

;;;; Startup speed

;; Effectively disable GC while init runs; restored after startup below.
(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.6)

;; Every `load' consults `file-name-handler-alist' (TRAMP, compressed files...).
;; Nothing during startup needs it, so drop it until init is done.
(defvar my--file-name-handler-alist file-name-handler-alist)
(setq file-name-handler-alist nil)

(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 32 1024 1024)
                  gc-cons-percentage 0.1
                  file-name-handler-alist
                  (delete-dups (append file-name-handler-alist
                                       my--file-name-handler-alist)))))

;;;; Packages

;; Activate packages from one precomputed autoloads file instead of one per
;; package.  package.el regenerates it on install, upgrade and delete.
(setq package-quickstart t)

;;;; Native compilation

;; Don't pop up the warnings buffer while packages compile in the background.
(setq native-comp-async-report-warnings-errors 'silent)

;;;; UI

(setq inhibit-startup-screen t
      initial-scratch-message nil)
(menu-bar-mode -1)

;;; early-init.el ends here
