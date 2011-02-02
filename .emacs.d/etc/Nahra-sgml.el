(load-from-site-lisp "psgml")
(require 'psgml)
;; (autoload 'sgml-mode "psgml" "Major mode to edit SGML files." t)
;; (autoload 'xml-mode "psgml" "Major mode to edit XML files." t)
;; (autoload 'html-mode "xxml" "Major mode to edit HTML files." t)


(setq sgml-validate-command "nsgmls -s %s %s"
      sgml-trace-entity-lookup t
      sgml-live-element-indicator t
      sgml-auto-activate-dtd t)


;; === faces ===
(setq sgml-set-face t)
;; create faces to assign to markup categories
(make-face 'sgml-comment-face)
(make-face 'sgml-start-tag-face)
(make-face 'sgml-end-tag-face)
(make-face 'sgml-entity-face)
(make-face 'sgml-doctype-face) ; DOCTYPE data
(make-face 'sgml-ignored-face) ; data ignored by PSGML
(make-face 'sgml-ms-start-face) ; marked sections start
(make-face 'sgml-ms-end-face) ; end of marked section
(make-face 'sgml-pi-face) ; processing instructions
(make-face 'sgml-sgml-face) ; the SGML declaration
(make-face 'sgml-shortref-face) ; short references

;; view a list of available colors with the emacs-lisp command:
;; list-colors-display
;; please assign your own groovy colors, because these are pretty bad
(set-face-foreground 'sgml-comment-face "green")
(set-face-foreground 'sgml-start-tag-face "green")
(set-face-foreground 'sgml-end-tag-face "magenta")
(set-face-foreground 'sgml-entity-face "lavender")
(set-face-foreground 'sgml-doctype-face "red")
(set-face-foreground 'sgml-ignored-face "lavender")
(set-face-foreground 'sgml-ms-start-face "lavender")
(set-face-foreground 'sgml-ms-end-face "lavender")
(set-face-foreground 'sgml-pi-face "lavender")
(set-face-foreground 'sgml-sgml-face "lavender")
(set-face-foreground 'sgml-shortref-face "yellow")

;; assign faces to markup categories
(setq sgml-markup-faces '
      (
       (comment . sgml-comment-face)
       (start-tag . sgml-start-tag-face)
       (end-tag . sgml-end-tag-face)
       (entity . sgml-entity-face)
       (doctype . sgml-doctype-face)
       (ignored . sgml-ignored-face)
       (ms-start . sgml-ms-start-face)
       (ms-end . sgml-ms-end-face)
       (pi . sgml-pi-face)
       (sgml . sgml-sgml-face)
       (shortref . sgml-shortref-face)
       ))


;; === DTDs ===
;; (eval-after-load "psgml"
;;   '(setq sgml-catalog-files (cons "~/emacs-datas/DTDs/CATALOG" sgml-catalog-files)))
;; (setq sgml-catalog-files '( "~/emacs-datas/DTDs/CATALOG" ))
;; (setq sgml-local-catalogs "~/emacs-datas/DTDs/CATALOG")
;; (add-to-list 'sgml-catalog-files "~/emacs-datas/DTDs/CATALOG")


;; === we add some keybindings ===
(setq sgml-mode-map (make-sparse-keymap))
(define-key sgml-mode-map "\C-v" 'yank)
(define-key sgml-mode-map "\C-d" 'Nahra/insert-link)
(define-key sgml-mode-map "\C-n" 'Nahra/insert-local-link)
(define-key sgml-mode-map "\C-z" 'Nahra/insert-spaced-link)
(define-key sgml-mode-map "\C-b" 'Nahra/insert-folder)
(define-key sgml-mode-map "\C-m" 'Nahra/insert-separator)


;; === hooks ===
(defun my-sgml-mode-hook ()
  (setq sgml-indent-step nil
        sgml-indent-data nil)
  (local-set-key (kbd "\C-v") 'yank)
  (local-set-key (kbd "\C-d") 'Nahra/insert-link)
  (local-set-key (kbd "\C-n") 'Nahra/insert-local-link)
  (local-set-key (kbd "\C-z") 'Nahra/insert-spaced-link)
  (local-set-key (kbd "\C-b") 'Nahra/insert-folder)
  (local-set-key (kbd "\C-a") 'Nahra/insert-separator)
  (local-set-key (kbd "RET")  'newline))

(defun my-xxml-mode-hook ()
  (setq xxml-indent-step nil
        xxml-indent-data nil))

(autoload 'xxml-mode-routine "xxml")
(add-hook 'xxml-mode-routine 'my-xxml-mode-hook)
(add-hook 'sgml-mode-hook 'xxml-mode-routine)
(add-hook 'sgml-mode-hook 'my-sgml-mode-hook)

