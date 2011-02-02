;; === color theme ===
(require 'color-theme)
(color-theme-initialize)

(load-library "themes/color-theme-tango")
(if window-system
    (color-theme-tango))
;; (if (not (window-system))
;;    (color-theme-tty-dark))


;; === fonts ===
(load-library "Nahra-fonts")
