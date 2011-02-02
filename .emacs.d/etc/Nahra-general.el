;; === encoding ===
(prefer-coding-system       'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-language-environment   'utf-8)
(setq default-buffer-file-coding-system 'utf-8)
;; (setq safe-local-variable-values (quote ((encoding . utf-8))))


;; === server ===
;; (setq-default server-socket-dir "~/emacs-datas/tmp/")
;; (setq-default server-name "server")


;; === bookmarks ===
(setq bookmark-default-file "~/emacs-datas/emacs.bmk")


;; === diary ===
;; (setq diary-file "~/emacs-datas/diary")


;; === searching ===
(setq case-fold-search t)


;; === printing ===
;; Pour l'impression, du papier au format A4 est utilisé
(setq ps-paper-type 'a4)

;; xpp, gtklp, kprinter
(setq lpr-command "gtklp")


;; === files ===
;; any files that change on disk where there are no changes in the buffer automatically revert to the on-disk version
(setq global-auto-revert-mode t)

;; Add Final Newline When Saving Files
(setq require-final-newline t)


;; backups
;; Don't clutter up directories with files~
(setq backup-directory-alist `(("." . ,(expand-file-name
                                        (concat "~/emacs-datas/" "backups")))))

;; auto-saving
(setq auto-save-list-file-prefix "~/emacs-datas/auto-save-list/.saves-")


;; === whitespaces ===
;; show them
(setq-default show-trailing-whitespace t)

;; delete whitespaces when saving a file
;; Note it's CRUCIAL to not use
;; before-save-hook, as it affects ALL
;; buffers, not just those in this major mode.
;; (add-hook 'write-file-hooks 'delete-trailing-whitespace)
(add-hook 'write-file-hooks (lambda ()
                              (delete-trailing-whitespace)))


;; === tabs ===
(setq-default tab-width 4) ; or any other preferred value
(setq-default standard-indent 4)

;; no tabs by default
;; modes that really need tabs should enable
;; indent-tabs-mode explicitly. makefile-mode already does that, for
;; example.
(setq-default indent-tabs-mode nil)
;; if indent-tabs-mode is off, untabify before saving
(add-hook 'write-file-hooks
          (lambda () (if (not indent-tabs-mode)
                         (untabify (point-min) (point-max)))))


;; === copy/paste/xclipboard ===
(when (eq system-type 'gnu/linux)

  ;; http://hugoheden.wordpress.com/2009/03/08/copypaste-with-emacs-in-terminal/
  ;; I prefer using the "clipboard" selection (the one the
  ;; typically is used by c-c/c-v) before the primary selection
  ;; (that uses mouse-select/middle-button-click)
  (setq x-select-enable-clipboard t)

  ;; If emacs is run in a terminal, the clipboard- functions have no
  ;; effect. Instead, we use of xsel, see
  ;; http://www.vergenet.net/~conrad/software/xsel/ -- "a command-line
  ;; program for getting and setting the contents of the X selection"
  (unless window-system
    ;; Callback for when user cuts
    (defun xsel-cut-function (text &optional push)
      ;; Insert text to temp-buffer, and "send" content to xsel stdin
      (with-temp-buffer
        (insert text)
        ;; I prefer using the "clipboard" selection (the one the
        ;; typically is used by c-c/c-v) before the primary selection
        ;; (that uses mouse-select/middle-button-click)
        (call-process-region (point-min) (point-max) "xsel" nil 0 nil "--clipboard" "--input")))
    ;; Call back for when user pastes
    (defun xsel-paste-function()
      ;; Find out what is current selection by xsel. If it is different
      ;; from the top of the kill-ring (car kill-ring), then return
      ;; it. Else, nil is returned, so whatever is in the top of the
      ;; kill-ring will be used.
      (let ((xsel-output (shell-command-to-string "xsel --clipboard --output")))
        (unless (string= (car kill-ring) xsel-output)
          xsel-output )))
    ;; Attach callbacks to hooks
    (setq interprogram-cut-function 'xsel-cut-function)
    (setq interprogram-paste-function 'xsel-paste-function)
    ;; Idea from
    ;; http://shreevatsa.wordpress.com/2006/10/22/emacs-copypaste-and-x/
    ;; http://www.mail-archive.com/help-gnu-emacs@gnu.org/msg03577.html
    ))


;; === abbrev ===
;; tell emacs where to read abbrev definitions from...
(setq abbrev-file-name "~/emacs-datas/abbrev/abbrev_defs")
;; save abbrevs when files are saved
;; you will be asked before the abbreviations are saved
(setq save-abbrevs t)


;; === file/mode associations ===
(add-to-list 'auto-mode-alist '("\\.c$"                                             . c-mode))
(add-to-list 'auto-mode-alist '("\\.\\(h\\|cpp\\|cc\\|hpp\\|cxx\\)$"                . c++-mode))
(add-to-list 'auto-mode-alist '("\\.ml[iylp]?$"                                     . caml-mode))
(add-to-list 'auto-mode-alist '("^TO_DO"                                            . change-log-mode))
(add-to-list 'auto-mode-alist '("\\.clj$"                                           . clojure-mode))
(add-to-list 'auto-mode-alist '("\\.cgi$"                                           . cperl-mode))
(add-to-list 'auto-mode-alist '("\\.\\([pP]\\([Llm]\\|[oO][dD]\\)\\|al\\)\\'"       . cperl-mode))
(add-to-list 'auto-mode-alist '("\\.css$"                                           . css-mode))
(add-to-list 'auto-mode-alist '("COMMIT_EDITMSG$"                                   . diff-mode))
(add-to-list 'auto-mode-alist '("\\.\\(diffs?\\|patch\\|rej\\)$"                    . diff-mode))
(add-to-list 'auto-mode-alist '("\\.\\(hrl\\|erl\\)?$"                              . erlang-mode))
(add-to-list 'auto-mode-alist '("\\.\\(gnuplot\\|gp\\)$"                            . gnuplot-mode))
;; (add-to-list 'auto-mode-alist '("\\.ht$"                                            . html-mode))
(add-to-list 'auto-mode-alist '("\\.\\(js\\|json\\)'"                               . javascript-mode))
(add-to-list 'auto-mode-alist '("\\.\\(la\\)?tex$"                                  . LaTeX-mode))
(add-to-list 'auto-mode-alist '("\\.ly$"                                            . LilyPond-mode))
(add-to-list 'auto-mode-alist '("\\.lua$"                                           . lua-mode))
(add-to-list 'auto-mode-alist '("\\.\\(md\\|markdown\\)$"                           . markdown-mode))
;; (add-to-list 'auto-mode-alist '("\\.\\(wml\\|htm\\|html\\|xhtml\\)$"                . nxhtml-mode))
(add-to-list 'auto-mode-alist '("\\.\\(xml\\|xsd\\|xsl\\|rng\\|svg\\|rss\\|rdf\\)$" . nxml-mode))
(add-to-list 'auto-mode-alist '("\\.\\(org\\|org_archive\\|TODO\\)$"                . org-mode))
(add-to-list 'auto-mode-alist '("\\.php$"                                           . php-mode))
(add-to-list 'auto-mode-alist '("\\.po$\\|\\.po\\."                                 . po-mode))
(add-to-list 'auto-mode-alist '("\\.pod$"                                           . pod-mode))
(add-to-list 'auto-mode-alist '("\\.pov$"                                           . pov-mode))
(add-to-list 'auto-mode-alist '("\\.pde$"                                           . processing-mode))
(add-to-list 'auto-mode-alist '("\\.plg$"                                           . prolog-mode))
(add-to-list 'auto-mode-alist '("Gemfile$"                                          . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.\\(irbrc\\|rake\\)$"                            . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.scm$"                                           . scheme-mode))
(add-to-list 'auto-mode-alist '("index$"                                            . sgml-mode))
(add-to-list 'auto-mode-alist '("\\.\\(sgm\\|sgml\\)$"                              . sgml-mode))
(add-to-list 'auto-mode-alist '(".ssh/config$"                                      . ssh-config-mode))
(add-to-list 'auto-mode-alist '("sshd?_config$"                                     . ssh-config-mode))
(add-to-list 'auto-mode-alist '("\\.ya?ml$"                                         . yaml-mode))

(add-to-list 'interpreter-mode-alist '("perl"                                       . cperl-mode))
(add-to-list 'interpreter-mode-alist '("perl5"                                      . cperl-mode))
(add-to-list 'interpreter-mode-alist '("miniperl"                                   . cperl-mode))
