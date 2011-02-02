(require 'cl)

;; === messages ===
;; (setq inhibit-startup-echo-area-message "Nahra")
;; when file is byte-compiled, prefer :
(eval '(setq inhibit-startup-echo-area-message "Nahra"))
;; pas d'écran d'accueil
(setq inhibit-startup-screen t)


(setq-default default-directory "~/.emacs.d/" )


;; Must be set before enabling ido mode.
(setq ido-save-directory-list-file "~/emacs-datas/ido/ido.last")


;; customize ne doit pas écrire dans ~/.emacs
(setq custom-file "~/emacs-datas/emacs-custom")
(load-file custom-file)


(defvar emacs-root (if (eq system-type 'windows-nt)
                       (concat (getenv "HOME") "\\")
                     (if (or (eq system-type 'gnu/linux) (eq system-type 'berkeley-unix))
                         (concat "/home/" user-login-name "/")
                       (if (eq system-type 'darwin)
                           (concat "/Users/" user-login-name "/"))))
  "My home directory the root of my personal emacs load-path.")


(labels ((add-path (p)
                   (add-to-list 'load-path
                                (concat emacs-root p))))
  (add-path ".emacs.d/etc")       ;; configuration files
  (add-path ".emacs.d/mylisp")    ;; personnal elisp code
  (add-path ".emacs.d/lisp")
  (add-path ".emacs.d/site-lisp") ;; elisp from the interwub
  )

;; system dependent configuration
(if (eq system-type 'windows-nt)
    (load-library "w32-setup")
  (if (or (eq system-type 'gnu/linux) (eq system-type 'berkeley-unix))
      (load-library "linux-setup")))

;; configuration
(load-library "Nahra-general.el")
(load-library "Nahra-visual.el")
(load-library "Nahra-keybindings")

(load-library "funcs")

;; extensions
(load-library "Nahra-utils")
(load-library "Nahra-cal")

;; (load-library "Nahra-cedet")
;; (load-library "Nahra-ecb")
;; (load-library "Nahra-jde")

;; (load-library "Nahra-javascript")
(load-library "Nahra-c")
(load-library "Nahra-perl")
(load-library "Nahra-haskell")
(load-library "Nahra-ocaml")
(load-library "Nahra-erlang")
(load-library "Nahra-lisp")
(load-library "Nahra-clojure")
(load-library "Nahra-lua")
(load-library "Nahra-sgml")
(load-library "Nahra-dtd")
(load-library "Nahra-auctex")
;; (load-library "Nahra-markdown")

(load-library "Nahra-org")
(load-library "Nahra-dictem")
(load-library "Nahra-gnuplot")
(load-library "Nahra-bbdb")
(load-library "Nahra-gnus")
;;(load-library "Nahra-w3m")

(load-library "Nahra-emms")
;; (load-library "Nahra-lilypond")
;; (load-library "Nahra-etxt")

;; pas encore valables
;; (load-library "Nahra-rcirc")
;; (load-library "Nahra-erc")
;; (load-library "Nahra-google")
;; (load-library "Nahra-processing")
;; (load-library "Nahra-predictive")
;; (load-library "Nahra-fonts")
;; (load-library "Nahra-company")
;; (load-library "Nahra-fortran")

;; linux-setup.el
;; w32-setup.el

(Nahra/org-agenda-to-appt)
