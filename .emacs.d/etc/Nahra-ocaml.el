(setq load-path (cons "~/.emacs.d/site-lisp/ocaml.emacs" load-path))

;;(autoload 'caml-mode "caml" "Major mode for editing Caml code." t)
(autoload 'caml-mode "ocaml" (interactive)
  "Major mode for editing Caml code." t)
(autoload 'run-caml "inf-caml" "Run an inferior Caml process." t)
(autoload 'camldebug "camldebug" (interactive) "Debug caml mode")

(if window-system (require 'caml-font))
