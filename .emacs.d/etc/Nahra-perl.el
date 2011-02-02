(fset 'perl-mode 'cperl-mode)
(require 'perltidy)

(defvaralias 'cperl-indent-level 'tab-width)
(setq cperl-indent-parens-as-block t)

;; (setq cperl-close-paren-offset -4
;;       cperl-continued-statement-offset 4
;;       cperl-indent-level 4
;;       cperl-indent-parens-as-block t
;;       cperl-tab-always-indent nil)

