(add-hook 'f90-mode-hook
          (lambda () (local-set-key (kbd "RET") 'reindent-then-newline-and-indent)))
