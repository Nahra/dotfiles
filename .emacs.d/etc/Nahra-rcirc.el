;; === bitlbee for rcirc ===
;; (autoload 'bitlbee-start "bitlbee" t)
;; (setq bitlbee-executable "/usr/local/sbin/bitlbee")

;; (global-set-key (kbd "C-c e")
;;                 (lambda ()
;;                     (interactive)
;;                       (bitlbee-start); needs time to start up
;;                         (run-with-idle-timer 1 nil 'rcirc nil)))


;; (eval-after-load 'rcirc '(load "~/emacs-datas/rcirc/rcircpass"))
;; (load "~/emacs-datas/rcirc/rcircpass")

;;; rcirc, write such as not to require rcirc at startup
(autoload 'rcirc "rcirc" t)


;; (setq rcirc-authinfo
;; '(("freenode" nickserv "Nahra" "Nahra:theonmax")
;;  ("OFTC" nickserv "Nahra" "theonmax")))

(setq rcirc-decode-coding-system 'undecided)

(setq rcirc-prompt "%t> "; list nick
      ;;      circ-authinfo-file-name "~/emacs-datas/rcirc/rcircpass.el"
      rcirc-fill-prefix "      "
      rcirc-fill-column 65; side-by-side on my laptop
      rcirc-log-flag t
      rcirc-log-directory "~/emacs-datas/rcirc/logs/"
      rcirc-default-nick "Nahra"
      rcirc-keywords '("Nahra" "nahra" "Nahra")
      rcirc-fill-flag nil
      rcirc-server-alist
      '(("irc.freenode.net" :channels
         ("#math" "#zsh" "##sed" "#xmonad" "#emacs" "#emacsfr" "#rcirc"
          "#gcu" "#pkgsrc" "#netbsd-code" "#NetBSD" "#NetBSDfr" "#archlinux" "#archlinux-fr"
          "#latex" "#clojure" "#Haskell" "##c" "#ocaml" "#ruby" "#perl" "##java" "#python" ))
      ;; ("irc.perl.org" :channels ("#perlde"))
      ;; ("irc.sorcery.net" :channels ("#rpmn"))
      ;; ("localhost" :channels ("&bitlbee" "&bsi" "&roleplaying" "&emacs"))
      ("irc.oftc.net" :channels ("#pwmt"))
      ("irc.gimp.org" :channels ("#NetBSD.se"))
      ("ircnet.eversible.com" :channels ("#NetBSD"))
      ("irc.efnet.org" :channels ("#NetBSD" "#dragonflybsd" "#tex")))

      ;;       rcirc-coding-system-alist
      ;;      '(("#nihongo" undecided . iso-2022-jp))
      ;;      rcirc-ignore-list '("jordanb" "consolers")

      rcirc-authinfo (with-temp-buffer
                       (insert-file-contents-literally "~/emacs-datas/rcirc/rcircpass")
                       (read (current-buffer))))

;; Merge rcirc-authinfo into rcirc-server-alist, because I patched
;; rcirc-server-alist in order to add :password support (and submitted
;; it).
;; (dolist (info rcirc-authinfo)
;;   (dolist (server rcirc-server-alist)
;;     (when (and (string-match (car info) (car server))
;;                       (not (plist-get (cdr server) :password)))
;;       (setcdr server (plist-put (cdr server) :password
;;                                       (nth 3 info))))))


;; === tracking, unfilling ===
(add-hook 'rcirc-mode-hook
          (lambda ()
            (rcirc-track-minor-mode 1)
            (local-set-key (kbd "M-q") 'rcirc-unfill)))

(defun rcirc-unfill ()
  (interactive)
  (save-excursion
    (goto-char rcirc-prompt-end-marker)
    (while (re-search-forward "\\s-+" nil t)
      (replace-match " "))))


;; six buffers for irc
(defun six-windows ()
  "Get rid of the current window configuration and have six of them instead.
Returns the list of windows."
  (delete-other-windows)
  (let* ((right-window (split-window-horizontally))
         (bottom-window (split-window-vertically (/ (window-height) 3))))
    (select-window bottom-window)
    (split-window-vertically)
    (select-window right-window)
    (setq bottom-window (split-window-vertically (/ (window-height) 3)))
    (select-window bottom-window)
    (split-window-vertically)
    (window-list)))

(defun six-irc-buffers ()
  "Return six `rcirc' buffers with a target."
  (loop for buf in (buffer-list)
        if (with-current-buffer buf
             (and (eq major-mode 'rcirc-mode)
                  rcirc-target))
        collect buf into buffers
        finally (return (subseq buffers 0 6))))

(defun six-irc-windows ()
  (interactive)
  (cl-mapc 'set-window-buffer
           (six-windows)
           (six-irc-buffers)))


;; === rcirc extensions ===
(eval-after-load 'rcirc '(require 'rcirc-pounce nil t))
(eval-after-load 'rcirc '(require 'rcirc-color nil t))
(eval-after-load 'rcirc '(require 'rcirc-controls nil t))
(eval-after-load 'rcirc '(require 'rcirc-notify nil t))

(setq rcirc-colors
      (let (candidates)
        (dolist (item color-name-rgb-alist)
          (destructuring-bind (color r g b) item
            (let ((d (sqrt (+ (* (/ r 512) (/ r 512))
                              (* (/ g 512) (/ g 512))
                              (* (/ b 512) (/ b 512))))))
              (if (and (not (= r g))
                       (not (= r b)); grey
                       (> d 10)
                       (< d 150))
                  (setq candidates (cons color candidates))))))
        candidates))


;; === encoding ===
(eval-after-load 'rcirc
  '(defun-rcirc-command encoding (arg)
     "Change the encoding coding system
`rcirc-encode-coding-system' for the current buffer only."
     (interactive)
     (if (string= arg "")
         (rcirc-print process (rcirc-nick process) "NOTICE" target
                      (symbol-name rcirc-encode-coding-system))
       (set (make-local-variable 'rcirc-encode-coding-system)
            (intern-soft arg)))))


;; === rcirc occur ===
(eval-after-load 'rcirc
  '(defun-rcirc-command occur (regexp)
     "Run `multi-occur' for all buffers in `rcirc-mode'."
     (interactive "sList lines matching regexp: ")
     (multi-occur (let (result)
                    (dolist (buf (buffer-list))
                      (with-current-buffer buf
                        (when (eq major-mode 'rcirc-mode)
                          (setq result (cons buf result)))))
                    result) regexp)))


;; ;; === faces ===
(defface rcirc-nick-in-message '((t (:background "lemon chiffon")))
  "My nick when mentioned by others.")
(defface rcirc-my-nick '((t (:foreground "purple")))
  "My own nick for rcirc.")
(defface rcirc-track-nick '((t (:inherit rcirc-my-nick)))
  "The face used indicate activity directed at you.")
(defface rcirc-nick-in-message-full-line '((t ()))
  "The face used emphasize the entire message when your nick is mentioned.")
(defface rcirc-track-keyword '((t (:inherit bold)))
  "The face used indicate activity directed at you.")
(defface rcirc-prompt '((t (:foreground "orchid")))
  "My prompt for rcirc.")


;; === channels aliases ===
;;(add-to-list 'rcirc-abbreviated-channels '("#opensolaris" . "#os"))


;; ;; Automatically rename Facebook users in Bitlbee

;; (defvar rcirc-facebook-name-from nil)
;; (defvar rcirc-facebook-name-to nil)

;; (defadvice rcirc-handler-PRIVMSG (after rcirc-handler-facebook-1 activate)
;;   "If &bitlbee mentions a user called u<number>,
;; this advice sets up a listener to get his real name and rename the user."
;;   ;; (when (string= sender "root")
;;   ;;   (message "%s %s %s" sender (nth 0 args) (nth 1 args)))
;;   (when (= 2 (length args))
;;     (cond ((and (string= "root" sender)
;;                 (or (string= "&bitlbee" (nth 0 args))
;;                         (string= rcirc-nick (nth 0 args)))
;;                 (string-match "\\(u[0-9]+\\)@chat.facebook.com"
;;                                     (nth 1 args)))
;;               (setq rcirc-facebook-name-from (match-string 1 (nth 1 args))))
;;             ((and (string= "root" sender)
;;                   (or (string= "&bitlbee" (nth 0 args))
;;                           (string= rcirc-nick (nth 0 args)))
;;                   (string-match "^Name: \\(.*\\)"
;;                                       (nth 1 args)))
;;                 (setq rcirc-facebook-name-to
;;                        (mapconcat 'identity
;;                                       (split-string (match-string 1 (nth 1 args)))
;;                                           ""))
;;                    (when rcirc-facebook-name-from
;;                           (rcirc-send-message process sender
;;                                                (format "rename %s %s"
;;                                                         rcirc-facebook-name-from
;;                                                          rcirc-facebook-name-to))))
;;               ((and (string= "root" sender)
;;                     (string= rcirc-nick (nth 0 args))
;;                     (string-match "^Nick `\\(.*\\)' already exists$"
;;                                         (nth 1 args)))
;;                   (setq to (concat (match-string 1 (nth 1 args)) "_"))
;;                      (when rcirc-facebook-name-from
;;                             (rcirc-send-message process sender
;;                                                  (format "rename %s %s"
;;                                                           rcirc-facebook-name-from
;;                                                            to)))))))

;; (defadvice rcirc-handler-JOIN (after rcirc-handler-facebook-2 activate)
;;   "If a user named u<number> joins channel &bitlbee,
;; call info on it. This will automatically rename him.
;; See advice on `rcirc-handler-PRIVMSG'."
;;   (when (and (string-match "^u[0-9]+$" sender)
;;                   (string= (car args) "&bitlbee"))
;;     (rcirc-send-message process "root"
;;                         (format "info %s" sender))))

