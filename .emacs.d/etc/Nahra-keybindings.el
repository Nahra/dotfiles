;; === <f3> ===
(global-set-key (kbd "<f3>")
                (lambda ()
                  (interactive)
                  (if (buffer-live-p emms-playlist-buffer)
                      (emms-playlist-mode-go)
                      ;; (emms-playlist-mode-go-popup)
                    (when (y-or-n-p "EMMS not started, start it now? ")
                      (emms-add-directory-tree
                       emms-source-file-default-directory)
                      (command-execute (kbd "<f3>"))))))


;; === <f5> ===
(global-set-key (kbd "<f5> b")      'bbdb)
(global-set-key (kbd "<f5> c")      'calendar)
(global-set-key (kbd "<f5> g")      'gnus)
(global-set-key (kbd "<f5> p")      'gnuplot-make-buffer)             ;; This line binds the function-9 key so that it opens a buffer into gnuplot mode
(global-set-key (kbd "<f5> v")      'visible-mode)
(global-set-key (kbd "<f5> w")      'whitespace-mode)


;; === <f6> ===
;; (global-set-key (kbd "<f6>")        'org-cycle-agenda-files)


;; === <f7> ===
(global-set-key (kbd "<f7>")        'org-agenda)


;; === <f8> ===
(global-set-key (kbd "<f8>")        'org-clock-goto)


;; === <f9> ===
(global-set-key (kbd "<f9> c")      'org-capture)
(global-set-key (kbd "<f9> t")      'Nahra/org-todo)
(global-set-key (kbd "<f9> p")      'Nahra/phone-call)
(global-set-key (kbd "<f9> w")      'Nahra/widen)

(global-set-key (kbd "<f9> I")      'Nahra/clock-in)
(global-set-key (kbd "<f9> O")      'Nahra/clock-out)
(global-set-key (kbd "<f9> P")      'org-publish-project)

(global-set-key (kbd "<f9> SPC")    'Nahra/clock-in-last-task)


;; === <F11> ===
(global-set-key (kbd "<f11> d")     'Nahra/debug-on-error)
(global-set-key (kbd "<f11> f")     'boxquote-insert-file)
(global-set-key (kbd "<f11> i")     'my-change-dictionary)
(global-set-key (kbd "<f11> r")     'boxquote-region)
(global-set-key (kbd "<f11> s")     'Nahra/go-to-scratch)
(global-set-key (kbd "<f11> t")     'Nahra/insert-inactive-timestamp)
(global-set-key (kbd "<f11> u")     'untabify)

(global-set-key (kbd "<f11> C")     'codepad-paste)
(global-set-key (kbd "<f11> N")     'netbsd-paste)
(global-set-key (kbd "<f11> P")     'pocoo-paste)
(global-set-key (kbd "<f11> S")     'sprunge-paste)


;; === <f12> ===
(global-set-key (kbd "<f12>")       'Nahra/bookmarks-search)


;; === M- ===
;; (global-set-key (kbd "M-RET")       'Nahra/ffap-quick)
(global-set-key (kbd "M-RET")       'Nahra/find-bookmarks)

(global-set-key (kbd "M-J")         (lambda () (interactive) (enlarge-window 1)))
(global-set-key (kbd "M-K")         (lambda () (interactive) (enlarge-window -1)))
(global-set-key (kbd "M-H")         (lambda () (interactive) (enlarge-window -1 t)))
(global-set-key (kbd "M-L")         (lambda () (interactive) (enlarge-window 1 t)))

(global-set-key (kbd "M-<f5>")      'org-resolve-clocks)
(global-set-key (kbd "M-<f9>")      (lambda ()
                                      (interactive)
                                      (unless (buffer-modified-p)
                                        (kill-buffer (current-buffer)))
                                      (delete-frame)))


;; === C- ===
(global-set-key (kbd "C-f")         'my-find-file)
;; (global-set-key (kbd "C-f")         'ido-find-file)
;; (global-set-key (kbd "C-f")         'find-file-in-root)
;; (global-set-key (kbd "C-f")         'find-file-save-default-directory)

(global-set-key (kbd "C-<f9>")      'previous-buffer)
(global-set-key (kbd "C-<f10>")     'next-buffer)
(global-set-key (kbd "C-<f11>")     'org-clock-in)
(global-set-key (kbd "C-x <down>")  'windmove-down)  ;; [M-down] 
(global-set-key (kbd "C-x <up>")    'windmove-up)    ;; [M-up] 
(global-set-key (kbd "C-x <left>")  'windmove-left)  ;; [M-left] 
(global-set-key (kbd "C-x <right>") 'windmove-right) ;; [M-right] 


;; === C-c
(global-set-key (kbd "C-c ;")       'comment-region)
(global-set-key (kbd "C-c .")       'uncomment-region)

(global-set-key (kbd "C-c e x")     'emms-start)
(global-set-key (kbd "C-c e v")     'emms-stop)
(global-set-key (kbd "C-c e n")     'emms-next)
(global-set-key (kbd "C-c e p")     'emms-previous)
(global-set-key (kbd "C-c e >")     'emms-cue-next)
(global-set-key (kbd "C-c e <")     'emms-cue-previous)
(global-set-key (kbd "C-c e o")     'emms-show)
(global-set-key (kbd "C-c e h")     'emms-shuffle)
(global-set-key (kbd "C-c e SPC")   'emms-pause)
(global-set-key (kbd "C-c e f")     'emms-no-next)
(global-set-key (kbd "C-c e F")     'emms-no-next-and-sleep)
(global-set-key (kbd "C-c e a")     'emms-add-directory-tree)
(global-set-key (kbd "C-c e d")     'emms-playlist-mode-delete-selected-track)
(global-set-key (kbd "C-c e r")     'emms-toggle-repeat-track)
(global-set-key (kbd "C-c e s")     'emms-lastfm-radio-similar-artists)
(global-set-key (kbd "C-c e k")     'emms-lastfm-radio-skip)

(global-set-key (kbd "C-c m s")     'dictem-run-search)          ;; Ask for word, database and search strategy and show definitions found
(global-set-key (kbd "C-c m m")     'dictem-run-match)           ;; Ask for word, database and search strategy and show matches found
(global-set-key (kbd "C-c m d")     'dictem-run-define)          ;; Ask for word and database name and show definitions found
(global-set-key (kbd "C-c m r")     'dictem-run-show-server)     ;; Show information about DICT server
(global-set-key (kbd "C-c m i")     'dictem-run-show-info)       ;; Show information about the database
(global-set-key (kbd "C-c m b")     'dictem-run-show-databases)  ;; Show a list of databases provided by DICT server

(global-set-key (kbd "C-c C-u")     'underline-region)


;; === C-x ===
(global-set-key (kbd "C-x a r")     'align-regexp)
(global-set-key (kbd "C-x c x")     (lambda()(interactive)(find-file "~/.xmonad/xmonad.hs")))
(global-set-key (kbd "C-x c i")     (lambda()(interactive)(find-file "~/.xinitrc")))
(global-set-key (kbd "C-x n r")     'narrow-to-region)

(global-set-key (kbd "C-x C-f")     'org-ido-switchb)


;; === C-s- ===
(global-set-key (kbd "C-s-<f12>")   'Nahra/save-then-publish)


;; === C-M- ===
(global-set-key (kbd "C-M-J")       (lambda () (interactive) (swap-with 'down)))
(global-set-key (kbd "C-M-K")       (lambda () (interactive) (swap-with 'up)))
(global-set-key (kbd "C-M-H")       (lambda () (interactive) (swap-with 'left)))
(global-set-key (kbd "C-M-L")       (lambda () (interactive) (swap-with 'right)))


;; === ESC ===
(global-set-key (kbd "ESC <down>")  'forward-paragraph)
(global-set-key (kbd "ESC <up>")    'backward-paragraph)


;; === RET ===
;; automatic indentation
(define-key global-map (kbd "RET")  'newline-and-indent)

