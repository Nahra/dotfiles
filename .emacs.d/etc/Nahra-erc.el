(load "~/emacs-datas/erc/ercpass")

(setq erc-server-coding-system 'utf-8)

;; (setq erc-user-full-name "Christophe Leboucher")
;; (setq erc-email-userid "kelaouchi@gmail.com")
(setq erc-nick "Nahra")

(require 'erc-join)
(erc-autojoin-mode 1)
(setq erc-autojoin-channels-alist
      '(
        (".*\\.freenode.net" "#mplayer" "#xmonad" "#xorg") 
        ("irc.belwue.de" "#NetBSD")
        ("irc.efnet.fr" "#NetBSD" "#tex")
        (".*\\.gimp.org" "#NetBSD.se")
        (".*\\.oftc.net" "#pwmt")
        ("irc.quakenet.org" "#NetBSD")))

(require 'erc-match)
(setq erc-keywords '("Nahra"))
(erc-match-mode)

(require 'erc-track)
(erc-track-mode t)

(add-hook 'erc-mode-hook
          '(lambda ()
             (require 'erc-pcomplete)
             (pcomplete-erc-setup)
             (erc-completion-mode 1)))

(require 'erc-fill)
;; (erc-fill-mode t)
(make-variable-buffer-local 'erc-fill-column)
(add-hook 'window-configuration-change-hook
          '(lambda ()
             (save-excursion
               (walk-windows
                (lambda (w)
                  (let ((buffer (window-buffer w)))
                    (set-buffer buffer)
                    (when (eq major-mode 'erc-mode)
                      (setq erc-fill-column (- (window-width w) 2)))))))))

(require 'erc-ring)
(erc-ring-mode t)

(require 'erc-netsplit)
(erc-netsplit-mode t)

(erc-timestamp-mode t)
(setq erc-timestamp-format "[%R-%m/%d]")

(erc-button-mode nil) ; slow

;; logging
(setq erc-log-insert-log-on-open nil
      erc-log-channels t
      erc-log-channels-directory "~/emacs-datas/erc/logs"
      erc-save-buffer-on-part t
      erc-hide-timestamps nil
      erc-log-file-coding-system 'utf-8)

(defadvice save-buffers-kill-emacs (before save-logs (arg) activate)
  (save-some-buffers t (lambda () (when (and (eq major-mode 'erc-mode)
                                             (not (null buffer-file-name)))))))

(add-hook 'erc-insert-post-hook 'erc-save-buffer-in-logs)
(add-hook 'erc-mode-hook '(lambda () (when (not (featurep 'xemacs))
                                       (set (make-variable-buffer-local
                                             'coding-system-for-write)
                                            'emacs-mule))))
;; end logging

;; Truncate buffers so they don't hog core.
(setq erc-max-buffer-size 20000)
(defvar erc-insert-post-hook)
(add-hook 'erc-insert-post-hook 'erc-truncate-buffer)
(setq erc-truncate-buffer-on-save t)

;; Clears out annoying erc-track-mode stuff for when we don't care.
;; Useful for when ChanServ restarts :P
(defun reset-erc-track-mode ()
  (interactive)
  (setq erc-modified-channels-alist nil)
  (erc-modified-channels-update))
(global-set-key (kbd "C-c r") 'reset-erc-track-mode)

;;; Finally, connect to the networks.
(defun irc-maybe ()
  "Connect to IRC."
  (interactive)
  (when (y-or-n-p "IRC? ")
    (erc :server "irc.freenode.net" :port 6667 :nick "erc-nick" :password freenode-passwd)
    (erc :server "irc.belwue.de" :port 6667 :nick "erc-nick")
    (erc :server "irc.efnet.fr" :port 6667 :nick "erc-nick")
    (erc :server "irc.gimp.org" :port 6667 :nick "erc-nick")
    (erc :server "irc.oftc.net" :port 6667 :nick "erc-nick" :password OFTC-passwd)
    (erc :server "irc.quakenet.org" :port 6667 :nick "erc-nick")
    ;; (erc :server "localhost" :port 6667 :nick "davidm")
    ))
