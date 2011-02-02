;; === erlware ===
(load-from-site-lisp "erlware-mode")
;; (setq load-path (cons "erlware-mode" load-path))
;; (setq erlang-man-root-dir "/usr/local/otp")
;; (setq exec-path (cons "/usr/local/otp/bin" exec-path))
(require 'erlang-start)


;; === distel ===
(add-to-list 'load-path "~/.emacs.d/site-lisp/distel/elisp")
(require 'distel)
(distel-setup)
