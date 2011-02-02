;; trouve des fichiers récursivement dans un dossier
(load-library "find-lisp")
(load-library "frame-cmds")


;; === emacs-goodies ===
;; Quote text with a semi-box
(load-library "boxquote")

;; underline the region with "^"
(autoload 'underline-region "under" "Underline the region" t)


;; === complétion ===
;; yasnippet mode
(load-from-site-lisp "yasnippet")
(require 'yasnippet)
(yas/initialize)
(yas/load-directory "~/.emacs.d/site-lisp/yasnippet/snippets")

;; hippie-expand mode
;; (require 'hippie-exp)
;; (global-set-key (kbd "M-/") 'hippie-expand)

;; ido mode
(when (> emacs-major-version 21)
  (require 'ido)
  (ido-mode t)
  (setq ido-create-new-buffer 'always
        ido-file-extensions-order '(".txt" ".xml" ".el" ".ini" ".cfg" ".cnf")
        ido-enable-prefix nil
        ido-enable-flex-matching t
        ido-use-filename-at-point nil
        ido-use-url-at-point nil
        ;; ido-enable-last-directory-history t
        ;; ido-record-commands t
        ;; ido-max-work-directory-list 100
        ;; ido-max-work-file-list 100
        ido-max-directory-size 500000
        ido-max-prospects 10
        ;; ido-ignore-buffers ;; ignore these guys
        ;; '("\\` " "^\*Mess" "^\*Back" ".*Completion" "^\*Ido")
        ;; do not confirm a new file or buffer
        confirm-nonexistent-file-or-buffer nil
        ;; wait for RET, even with unique completion
        ido-confirm-unique-completion t
        ;; on utilise ffap pour ça, donc :
        ;; ido-work-directory-list-ignore-regexps '("/home/Nahra/public_html/BOOKMARKS/*")
        ))

(add-hook 'ido-make-buffer-list-hook 'ido-summary-buffers-to-end)


;; auto-complete mode
(load-from-site-lisp "auto-complete")
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/site-lisp/auto-complete/dict")
(setq ac-comphist-file  "~/emacs-datas/auto-complete/ac-comphist.dat")
(ac-config-default)


;; === files ===
;; (ffap-bindings)


;; ;; on set un default-directory pour toujours
(defun my-find-file ()
  "force a starting path"
  (interactive)
  (let ((default-directory "~/.emacs.d/"))
    (call-interactively 'ido-find-file)))

;; (defvar find-file-root-dir "~/"
;;   "Directory from which to start all find-file's")
;; (defun find-file-in-root ()
;;   "Make find-file always start at some root directory."
;;   (interactive)
;;   (let ((default-directory find-file-root-dir))
;;     (call-interactively 'ido-find-file)))

;; ;; Prevent Emacs from stupidly auto-changing my working directory
;; (defmacro disallow-cd-in-function (fun)
;;   "Prevent FUN (or any function that FUN calls) from changing directory."
;;   `(defadvice ,fun (around dissallow-cd activate)
;;      (let ((old-dir default-directory) ; Save old directory
;;            (new-buf ad-do-it)) ; Capture new buffer
;;        ;; If FUN returns a buffer, operate in that buffer in addition
;;        ;; to current one.
;;        (when (bufferp new-buf)
;;          (set-buffer new-buf)
;;          (setq default-directory old-dir))
;;        ;; Set default-directory in the current buffer
;;        (setq default-directory old-dir))))

;; (disallow-cd-in-function find-file-noselect-1)
;; (disallow-cd-in-function set-visited-file-name)


;; === parenthesis ===
(require 'autopair)
;; to enable in all buffers
(autopair-global-mode)

;; autocomplete (, {, [
;;(require 'pair-mode)
;;(pair-mode t)


;; === window navigation ===
(windmove-default-keybindings)

(defun swap-with (dir)
  (interactive)
  (let ((other-window (windmove-find-other-window dir)))
    (when other-window
      (let* ((this-window  (selected-window))
             (this-buffer  (window-buffer this-window))
             (other-buffer (window-buffer other-window))
             (this-start   (window-start this-window))
             (other-start  (window-start other-window)))
        (set-window-buffer this-window  other-buffer)
        (set-window-buffer other-window this-buffer)
        (set-window-start  this-window  other-start)
        (set-window-start  other-window this-start)))))


;; === tramp ===
(setq tramp-persistency-file-name "~/emacs-datas/tramp/tramp")


;; === debugging ===
(defun Nahra/debug-on-error ()
  (interactive)
  (setq debug-on-error (not debug-on-error))
  (message "Debug on Error is %s" debug-on-error))


;; === magit mode ===
(load-from-site-lisp "magit")
(autoload 'magit-status "magit" nil t)
(global-set-key "\C-ci" 'magit-status)


;; === encryption ===
;;; EasyPG
(require 'epa)
;; (epa-file-enable)


;; === spelling ===
(require 'flyspell)
(require 'ispell)

(setq ispell-program-name "aspell"
      ispell-extra-args '("--sug-mode=ultra") ;; tell `aspell' to speed up, though this reduces somewhat
      ;; the quality of its suggestions. According to the
      ;; `aspell' documentation:
      ;; - "ultra" is the fastest suggestion mode, which is
      ;;   still twice as slow as `ispell'.
      ;; - If your machine is fast enough, a better option might
      ;;   be to try "fast" mode, which is twice as slow as
      ;;   "ultra", but more accurate.
      ;; - The "normal" mode, which is the `aspell' default, is
      ;;   even more accurate, but is reportedly 10 times slower
      ;;   than "fast" mode.
      ispell-have-new-look t
      ispell-highlight-face 'flyspell-incorrect
      ispell-dictionary "fr_FR"

      flyspell-delay 1
      flyspell-issue-message-flag nil         ;; no messages, while checking
      flyspell-mark-duplications-flag nil     ;; don't consider that a word repeated twice is an error
      flyspell-default-dictionary "fr_FR")

(defun my-change-dictionary ()
  "Change the dictionary."
  (interactive)
  (let ((dict (or ispell-local-dictionary ispell-dictionary)))
    (setq dict (if (string= dict "fr_FR") "en_US" "fr_FR"))
    (message "Switched to %S" dict)
    (sit-for 0.4)
    (ispell-change-dictionary dict)
    (when flyspell-mode
      (flyspell-delete-all-overlays)
      (flyspell-buffer))))

;; (defun fd-switch-dictionary()
;;   (interactive)
;;   (let* ((dic ispell-current-dictionary)
;;          (change (if (string= dic "french") "english" "french")))
;;     (ispell-change-dictionary change)
;;     (message "Dictionary switched from %s to %s" dic change)
;;     ))
;; (global-set-key (kbd "<f8>")   'fd-switch-dictionary)

(add-hook 'message-mode-hook 'turn-on-flyspell)
;; (add-hook 'text-mode-hook 'turn-on-flyspell)
;; (add-hook 'texinfo-mode-hook 'turn-on-flyspell)
;; (add-hook 'TeX-mode-hook 'turn-on-flyspell)

;; (add-hook 'crontab-mode-hook 'flyspell-prog-mode)
;; (add-hook 'shell-mode-hook 'flyspell-prog-mode)

;;----------------------------------------------------------------------------
;; Add spell-checking in comments for programming language modes
;;----------------------------------------------------------------------------
;; (dolist (hook '(autoconf-mode-hook
;;                 ;; autotest-mode-hook
;;                 c++-mode-hook
;;                 c-mode-common-hook
;;                 caml-mode-hook
;;                 ;; clojure-mode-hook
;;                 css-mode-hook
;;                 emacs-lisp-mode-hook
;;                 haskell-mode-hook
;;                 java-mode-common-hook
;;                 javascript-mode-hook
;;                 lisp-mode-hook
;;                 makefile-mode-hook
;;                 nxml-mode-hook
;;                 pascal-mode-hook
;;                 perl-mode-hook
;;                 ;; php-mode-hook
;;                 python-mode-hook
;;                 ruby-mode-hook
;;                 scheme-mode-hook
;;                 sh-mode-hook
;;                 tcl-mode-hook
;;                 yaml-mode))
;;   (add-hook hook 'flyspell-prog-mode))


;; === paste ===
(defun sprunge-paste (&optional b e)
  (interactive "r")
  (shell-command-on-region b e "sprunge" "paste")
  (with-current-buffer "paste"
    (progn
      ;; (goto-char (point-min))
      ;; (delete-char 1)
      (goto-char (point-max))
      (delete-char -1)
      (copy-region-as-kill (point-min) (point-max)))))

(defun netbsd-paste (&optional b e)
  (interactive "r")
  (shell-command-on-region b e "pastebinit -b http://netbsd.pastebin.com" "paste")
  (with-current-buffer "paste"
    (progn
      ;; (goto-char (point-min))
      ;; (delete-char 1)
      (goto-char (point-max))
      (delete-char -1)
      (copy-region-as-kill (point-min) (point-max)))))

(defun codepad-paste (&optional b e)
  (interactive "r")
  (shell-command-on-region b e "wgetpaste -s codepad" "paste")
  (with-current-buffer "paste"
    (progn
      ;; (goto-char (point-min))
      ;; (delete-char 1)
      (goto-char (point-max))
      (delete-char -1)
      (copy-region-as-kill (point-min) (point-max)))))

(defun pocoo-paste (&optional b e)
  (interactive "r")
  (shell-command-on-region b e "wgetpaste -s pocoo" "paste")
  (with-current-buffer "paste"
    (progn
      ;; (goto-char (point-min))
      ;; (delete-char 1)
      (goto-char (point-max))
      (delete-char -1)
      (copy-region-as-kill (point-min) (point-max)))))


;; === HTML Tidy - http://www.emacswiki.org/emacs/tidy.el ===
;; (require 'tidy)
;; (setq tidy-config-file "~/.tidy.rc"
;;       tidy-temp-dir "~/tmp/tidy"
;;       tidy-shell-command "/usr/bin/tidy -m -config $HOME/.tidy.rc"
;;       )

;; (autoload 'tidy-buffer "tidy" "Run Tidy HTML parser on current buffer" t)
;; (autoload 'tidy-parse-config-file "tidy" "Parse the `tidy-config-file'" t)
;; (autoload 'tidy-save-settings "tidy" "Save settings to `tidy-config-file'" t)
;; (autoload 'tidy-build-menu  "tidy" "Install an options menu for HTML Tidy." t)

;; (defun my-html-mode-hook () "Customize my html-mode."
;;   (tidy-build-menu html-mode-map)
;;   (local-set-key [(control c) (control c)] 'tidy-buffer)
;;   ;; (setq sgml-validate-command "tidy")
;;   )

;; (defun my-org-mode-hook () "Customize my html-mode."
;;   (tidy-buffer org-mode-map)
;;   (local-set-key [(control c) (control c)] 'tidy-buffer)
;;   ;; (setq sgml-validate-command "tidy")
;;   )

;; (add-hook 'html-mode-hook 'my-html-mode-hook)
;; (add-hook 'sgml-html-mode-hook #'(lambda () (tidy-build-menu sgml-html-mode-map)))
;; (add-hook 'xml-html-mode-hook #'(lambda () (tidy-build-menu xml-html-mode-map)))
