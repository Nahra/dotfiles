(load-from-site-lisp "auctex")
(load-file "~/.emacs.d/site-lisp/auctex/auctex.el")
(load-file "~/.emacs.d/site-lisp/auctex/preview-latex.el")

;; Activer le bon dictionnaire, mettre les guillemets francais
;; passage a la ligne automatok et correction ortho et utilisation
;; des references bibtex quand on entre dans le mode latex
(add-hook 'LaTeX-mode-hook
          '(lambda ()
             (ispell-change-dictionary "francais")
             (setq TeX-open-quote "«~")
             (setq TeX-close-quote "~»")
             (auto-fill-mode t)
             (abbrev-mode t)
             (read-abbrev-file)
             ;; (flyspell-mode t)
             (turn-on-reftex)
             )
          )

;; Que faire quand on crée un nouveau doc .tex
;; ecriture de l'entete
;; (add-hook 'LaTeX-document-style-hook
;;           '(lambda ()
;;              (previous-line 1)
;;              (insert "\\usepackage[french]{babel}")
;;              (newline 1)
;;              (insert "\\usepackage[latin1]{inputenc}")
;;              (newline 1)
;;              (insert "\\usepackage[T1]{fontenc}")
;;              (newline 1)
;;              (insert "\\usepackage{a4wide}")
;;              (newline 1)
;;              (next-line 1)
;;              )
;;           )
