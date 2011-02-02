;; No 'yes or no' question, only 'y or n'
(fset 'yes-or-no-p 'y-or-n-p)


;; === frames ===
(setq frame-background-mode 'dark)
;; pas de scroll-bar, pas de barre d'outils, pas de menu
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))


;; === windows ===
;; window management
(winner-mode 1)

;; title
(setq frame-title-format '(buffer-file-name "Emacs: %b (%f)" "Emacs: %b"))


;; === lines ===
;; (setq truncate-lines t)


;; === curseur ===
;; Laisser le curseur en place lors d'un défilement par pages.
;; Par défaut, Emacs place le curseur en début ou fin d'écran
;; selon le sens du défilement.
(setq scroll-preserve-screen-position t)

;; virer le  curseur quand il est chiant
(mouse-avoidance-mode  'exile)

;; se rappeler de la position dans le fichier entre les sessions
(setq-default save-place t)
(setq save-place-file "~/emacs-datas/emacs-places")
(require 'saveplace)


;; === modeline ===
(setq display-time-mode t
      size-indication-mode t)


;; === highlighting ===
;; occurences of selected symbol
(load-library "light-symbol")
(light-symbol-mode)

;; selection
(transient-mark-mode t)

;; better i-search highlight
(require 'ishl)

;; current line
(require 'highlight-current-line)
(highlight-current-line-set-bg-color
 (plist-get (custom-face-attributes-get 'fringe nil) :foreground))
(highlight-current-line-set-bg-color "#363943")
;;(highlight-current-line-minor-mode)
(highlight-current-line-on t)


;; === syntax color ===
(global-font-lock-mode t)
;; colors > 9000
(setq font-lock-maximum-decoration t)


;; === parenthesis matching ===
(show-paren-mode 1)
(setq-default hilight-paren-expression t)


;; === compilation console ===
(setq compilation-window-height 10)


;; === clock ===
(display-time)
(setq display-time-24hr-format t)


;; === column/line numbers ===
(setq column-number-mode t
      line-number-mode t)


;; === ring bell ===
;; disable sound
;; (setq visible-bell t)
(setq ring-bell-function (lambda () (message "*beep*")))

;; (setq ring-bell-function
;;       (lambda ()
;;      (unless (memq this-command
;;                    '(isearch-abort abort-recursive-edit exit-minibuffer keyboard-quit))
;;        (ding))))


;; ;; === indentation ===
;; ;; indenter automatiquement le code collé :
;; (defadvice yank (after indent-region activate)
;;   ;; (if (member major-mode '(emacs-lisp-mode scheme-mode lisp-mode
;;   ;;                                          c-mode c++-mode objc-mode
;;   ;;                                          java-mode html-mode
;;   ;;                                          javascript-mode php-mode ruby-mode
;;   ;;                                          lua-mode yaml-mode
;;   ;;                                          prolog-mode erlang-mode
;;   ;;                                          latex-mode plain-tex-mode
;;   ;;                                          python-mode))
;;       (indent-region (region-beginning) (region-end) nil))
;; (defadvice yank-pop (after indent-region activate)
;;   ;; (if (member major-mode '(emacs-lisp-mode scheme-mode lisp-mode
;;   ;;                                          c-mode c++-mode objc-mode
;;   ;;                                          java-mode html-mode
;;   ;;                                          javascript-mode php-mode ruby-mode
;;   ;;                                          lua-mode yaml-mode
;;   ;;                                          prolog-mode erlang-mode
;;   ;;                                          latex-mode plain-tex-mode
;;   ;;                                          python-mode))
;;       (indent-region (region-beginning) (region-end) nil))

;; ;; Normally, killing the newline between indented lines doesn’t remove any extra spaces caused by indentation. That is, placing the cursor (symbolized by []) at
;; ;;         AAAAAAAAAA[]
;; ;;         AAAAAAAAAA
;; ;; and pressing C-k (bound to kill-line) results in
;; ;;         AAAAAAAAAA[]        AAAAAAAAAA
;; ;; when it might be more desirable to have
;; ;;         AAAAAAAAAA[]AAAAAAAAAA
;; (defadvice kill-line (before check-position activate)
;;   (if (and (eolp) (not (bolp)))
;;       (progn (forward-char 1)
;;              (just-one-space 0)
;;              (backward-char 1))))
