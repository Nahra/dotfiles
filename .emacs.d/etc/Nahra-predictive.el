;; predictive install location
(add-to-list 'load-path "~/.emacs.d/site-lisp/predictive")

;; dictionary locations
(add-to-list 'load-path "~/emacs-datas/predictive")
(add-to-list 'load-path "~/emacs-datas/predictive/texinfo")
(add-to-list 'load-path "~/emacs-datas/predictive/latex")
(add-to-list 'load-path "~/emacs-datas/predictive/html")

;; load predictive package
(require 'predictive)
;; or autoload
;; (autoload 'predictive-mode "predictive" "predictive" t)

;; (set-default 'predictive-auto-add-to-dict t)
(add-to-list 'predictive-mode-hook
             (lambda () (setq predictive-auto-add-to-dict t)))

(setq predictive-main-dict 'dict-Nahra
      predictive-add-to-dict-ask nil
      predictive-auto-learn t
      predictive-use-auto-learn-cache nil
      predictive-dict-autosave t
      predictive-which-dict t
      predictive-completion-speed 0.01
      completion-auto-show-delay 0.3)

(dolist (hook (list
               ;; 'erc-mode-hook
               ;; 'rcirc-mode-hook
               'message-mode-hook
               'org-mode-hook
               ;; 'yaoddmuse-mode-hook
               ))
  (add-hook hook '(lambda () (predictive-mode 1))))
