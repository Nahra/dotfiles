(autoload 'LilyPond-mode "lilypond-mode" "LilyPond Editing Mode" t)
(add-hook 'LilyPond-mode-hook (lambda () (turn-on-font-lock)))

(provide 'lilypond-init)
