;;; init.el --- Rust-focused terminal Emacs  -*- lexical-binding: t; -*-

;;; Commentary:
;; Built in:  rust-ts-mode, eglot, flymake, xref, eldoc, project, compile.
;; Packages:  corfu, vertico, orderless, marginalia (all on GNU ELPA).
;; Rust tooling loads only when the first .rs file is opened.
;; Check startup cost with M-x emacs-init-time.
;;
;; Per-project settings go in .dir-locals.el at the project root, e.g.:
;;   ((nil . ((my/mise-default-task . "build")))
;;    (rust-ts-mode . ((eglot-workspace-configuration
;;                      . (:rust-analyzer (:cargo (:features "all")
;;                                         :check (:command "clippy")))))))

;;; Code:

;;;; Packages

(defvar my/packages '(corfu vertico orderless marginalia)
  "Packages this config needs.")

;; Install anything missing (first run only).  `locate-library' is a cheap
;; load-path scan, so normal startups never load package.el.
(let (missing)
  (dolist (pkg my/packages)
    (unless (locate-library (symbol-name pkg))
      (push pkg missing)))
  (when missing
    (require 'package)
    (package-refresh-contents)
    (dolist (pkg (nreverse missing))
      (package-install pkg))))

;; Keep Customize (and package.el's bookkeeping) out of this file.
(setq custom-file (locate-user-emacs-file "custom.el"))
(load custom-file 'noerror 'nomessage)

;;;; General

(setq use-short-answers t
      ring-bell-function #'ignore
      ;; TAB indents, or completes if the line is already indented.
      tab-always-indent 'complete
      ;; Keep backup files and lock files out of project trees (lock files
      ;; can also trigger file watchers such as bacon or cargo-watch).
      backup-directory-alist `(("." . ,(locate-user-emacs-file "backups/")))
      create-lockfiles nil
      ;; rust-analyzer sends large JSON payloads; read more per chunk.
      read-process-output-max (* 1024 1024))

(setq-default indent-tabs-mode nil)
(column-number-mode 1)

;; Optional: a built-in theme instead of the terminal's palette (costs a few ms).
;; (load-theme 'modus-vivendi t)

;;;; Terminal: mouse and macOS clipboard

(unless (display-graphic-p)
  ;; With this on, hold Option while dragging for a native terminal selection.
  (xterm-mouse-mode 1))

(when (and (eq system-type 'darwin) (not (display-graphic-p)))
  (defun my/pbcopy (text)
    "Copy TEXT to the macOS clipboard."
    (let* ((process-connection-type nil)
           (proc (start-process "pbcopy" nil "pbcopy")))
      (set-process-coding-system proc 'utf-8 'utf-8)
      (process-send-string proc text)
      (process-send-eof proc)))

  (defun my/pbpaste ()
    "Return the macOS clipboard, unless it is empty or matches the last kill."
    (let ((text (with-temp-buffer
                  (let ((coding-system-for-read 'utf-8))
                    (call-process "pbpaste" nil t nil))
                  (buffer-string))))
      (unless (or (string= text "")
                  (equal text (car kill-ring)))
        text)))

  (setq interprogram-cut-function #'my/pbcopy
        interprogram-paste-function #'my/pbpaste))

;;;; Minibuffer completion: vertico + orderless + marginalia

(use-package vertico
  :hook (after-init . vertico-mode))

(use-package marginalia
  :hook (after-init . marginalia-mode))

(use-package orderless
  :custom
  ;; Space-separated fragments in any order: "tok mod" -> crates/tokens/src/mod.rs
  (completion-styles '(orderless basic))
  ;; Drop per-category defaults (including eglot's) so orderless applies
  ;; everywhere, except file names, where partial-completion expands
  ;; ~/.c/e to ~/.config/emacs.
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion)))))

;;;; In-buffer completion: corfu

(use-package corfu
  :hook (prog-mode . corfu-mode)
  :custom
  (corfu-auto t)                       ; pop up while typing
  (corfu-auto-delay 0.2)
  (corfu-auto-prefix 2)
  (corfu-cycle t)
  (corfu-popupinfo-delay '(0.5 . 0.2))
  :config
  (corfu-popupinfo-mode 1))            ; docs beside the candidate list

;;;; Rust

(use-package rust-ts-mode
  :mode "\\.rs\\'"
  :init
  ;; Fallback grammar recipe, pinned, in case this Emacs doesn't provide one.
  ;; Install manually with: M-x treesit-install-language-grammar RET rust RET
  (with-eval-after-load 'treesit
    (unless (assq 'rust treesit-language-source-alist)
      (add-to-list 'treesit-language-source-alist
                   '(rust "https://github.com/tree-sitter/tree-sitter-rust" "v0.23.2")))))

(use-package eglot
  :hook (rust-ts-mode . eglot-ensure)
  :bind (:map eglot-mode-map
         ("C-c a" . eglot-code-actions)
         ("C-c R" . eglot-rename)
         ("C-c f" . eglot-format-buffer))
  :config
  (setq eglot-autoshutdown t                         ; stop server with last buffer
        eglot-events-buffer-config '(:size 0 :format full)) ; no JSON-RPC logging
  ;; Default rust-analyzer settings.  A .dir-locals.el value replaces this
  ;; whole plist (it is not merged).  Not marked safe on purpose:
  ;; rust-analyzer settings can run commands, so Emacs asks once per value.
  (setq-default eglot-workspace-configuration
                '(:rust-analyzer (:check (:command "clippy")))))

;;;; Diagnostics

(use-package flymake
  :bind (:map flymake-mode-map
         ("M-n"   . flymake-goto-next-error)
         ("M-p"   . flymake-goto-prev-error)
         ("C-c d" . flymake-show-buffer-diagnostics)
         ("C-c D" . flymake-show-project-diagnostics)))

;;;; Building and testing: compile + mise

(use-package compile
  :defer t
  :config
  (setq compilation-scroll-output 'first-error
        compilation-ask-about-save nil)              ; save buffers silently
  ;; Stop mise prefixing output lines with [task], which breaks error matching.
  (add-to-list 'compilation-environment "MISE_TASK_OUTPUT=interleave")
  (add-hook 'compilation-filter-hook #'ansi-color-compilation-filter)
  ;; Clickable rustc diagnostics and test panics, unless Emacs ships a matcher.
  (unless (or (assq 'cargo compilation-error-regexp-alist-alist)
              (assq 'rust compilation-error-regexp-alist-alist))
    (add-to-list 'compilation-error-regexp-alist-alist
                 '(my-rustc
                   "^\\(?:error\\|\\(warning\\)\\)[^\n]*\n[ \t]*--> \\([^\n:]+\\):\\([0-9]+\\):\\([0-9]+\\)"
                   2 3 4 (1)))
    (add-to-list 'compilation-error-regexp-alist-alist
                 '(my-rust-panic
                   "panicked at \\([^\n:]+\\):\\([0-9]+\\):\\([0-9]+\\)"
                   1 2 3))
    (add-to-list 'compilation-error-regexp-alist 'my-rustc)
    (add-to-list 'compilation-error-regexp-alist 'my-rust-panic)))

(defvar-local my/mise-default-task nil
  "Default task for `my/mise-run'.  Set per project in .dir-locals.el.")
(put 'my/mise-default-task 'safe-local-variable #'stringp)

(defvar my/mise-task-history nil
  "Minibuffer history for `my/mise-run'.")

(defun my/project-root ()
  "Root of the current project, or `default-directory' outside one."
  (if-let* ((project (project-current)))
      (project-root project)
    default-directory))

(defun my/mise-tasks (dir)
  "Return the names of the mise tasks available in DIR."
  (let ((default-directory dir))
    (condition-case nil
        (mapcar (lambda (task) (gethash "name" task))
                (json-parse-string
                 (shell-command-to-string "mise tasks ls --json 2>/dev/null")))
      (error nil))))

(defun my/mise-run (task)
  "Run mise TASK from the project root via `compile'.
Arguments can follow the task name, e.g. \"test -- --nocapture\".
Press `g' in the compilation buffer to re-run."
  (interactive
   (let ((default-directory (my/project-root)))
     (list (completing-read (format-prompt "mise task" my/mise-default-task)
                            (my/mise-tasks default-directory)
                            nil nil nil 'my/mise-task-history
                            my/mise-default-task))))
  (let ((default-directory (my/project-root)))
    (compile (concat "mise run " task))))

(keymap-global-set "C-c m" #'my/mise-run)

;;; init.el ends here
