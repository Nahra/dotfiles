(load-from-site-lisp "bbdb/lisp")
(require 'bbdb)

(add-to-list 'Info-default-directory-list "bbdb/tex")

;; intégration de bbdb à gnus
(bbdb-initialize 'gnus 'message)
;; (bbdb-initialize 'gnus 'message 'sc 'w3)


;; === general settings ===
(setq
 bbdb-file "~/emacs-datas/bbdb/bbdb"
 bbdb-file-coding-system 'utf-8
 ;; nombre de lignes desiré dans la fenêtre popup de bbdb lorsque l'on utilise VM/MH/RMAIL ou GNUS.
 bbdb-pop-up-target-lines 15
 bbdb-always-add-addresses nil
 ;; ne pas m'enquiquiner si bbdb voit un correspondant connu avec une adresse différente
 bbdb-quiet-about-name-mismatches t
 ;; ne pas me demander si je veux sauver la base
 bbdb-offer-save 'savenoprompt)


;; === adresses postales ===
(setq
 ;; ne check pas le code postal
 bbdb-check-zip-codes-p nil
 bbdb-default-country "FRANCE"
 bbdb-continental-zip-regexp "^\\s *\\([A-Z][A-Z]?\\s *-\\s *\\)?[0-9][0-9][0-9] ?[0-9][0-9]?")


;; === adreaases mails ===
(setq
 ;; allow cycling of email addresses
 bbdb-complete-name-allow-cycling t
 ;; on empêche bbdb de créer une nouvelle entrée à chaque fois
 ;; qu'un mail d'une nouvelle personne est lu avec GNUS, RMAIL,
 ;; VM ou MH.
 bbdb/mail-auto-create-p nil
 bbdb/news-auto-create-p nil)


;; === numéros de téléphone ===
(setq
 ;; on ne veut pas des numéros de téléphone au format américain
 bbdb-north-american-phone-numbers-p nil
 ;; la France par défaut
 bbdb-default-area-code '+33
 ;; labels
 bbdb-phones-label-list '("maison" "permanence" "ligne directe" "standard" "accueil" "atelier" "bureau" "cabinet" "travail" "magasin" "mobile" "mobile pro" "serveur vocal" "support technique" "support commercial" "sip" "fax"))


;; === bbdb-print ===
;; (require 'bbdb-print)
(add-hook 'bbdb-load-hook (function (lambda () (require 'bbdb-print))))

(setq
 bbdb-print-file-name "~/emacs-datas/bbdb/bbdb.tex"
 ;; bbdb-print-require '(and name (or address phone))
 bbdb-print-omit-fields '(omit tex-name aka creation-date timestamp)
 ;; print all mail adresses
 bbdb-print-net 'all
 ;; for A4, RV, 3 columns
 bbdb-print-full-alist
 '((separator . 2)
   (columns . 3)
   (ps-fonts . t)
   (font-size . 7)
   (include-files "bbdb-print" "bbdb-cols" "brucks" "pagination"))
 ;; for filofax
 ;; '((separator . 2)
 ;;   (voffset . "-2cm")
 ;;   ;; recto
 ;;   (hoffset . "-1cm")
 ;;   ;; verso
 ;;   ;;    (hoffset . "12.1cm")
 ;;   (hsize . "4.7cm")
 ;;   (vsize . "8.5cm")
 ;;   (columns . 1)
 ;;   (quad-hsize . "4.7cm")
 ;;   (quad-vsize . "9.5cm")
 ;;   (ps-fonts . t)
 ;;   (font-size . 5)
 ;;   ;; (phone-on-first-line . "^[  ]*$")
 ;;   ;; (include-files "bbdb-print" "bbdb-cols" "~/latex/macros/brucks.tex"))
 ;;   (include-files "bbdb-print" "bbdb-cols" "brucks" "pagination"))
 )


;; === bbdb-anniv ===
(load-from-site-lisp "bbdb/bits")
(require 'bbdb-anniv)
;; (setq bbdb-anniversary-reminder-days 7)
(setq bbdb-anniversary-field "anniversaire")
