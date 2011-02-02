;; === reload .emacs on the fly ====
(defun reload-dot-emacs()
  (interactive)
  (if(bufferp (get-file-buffer "init.el"))
      (save-buffer(get-buffer "init.el")))
  (load-file "~/.emacs.d/init.el")
  (message ".emacs reloaded successfully"))

(defun prepend-to-path (path)
  (setq load-path (cons (concat emacs-root path) load-path)))

(defun load-from-site-lisp (name)
  (prepend-to-path (concat ".emacs.d/site-lisp/" name)))


;; === word count ===
;; (defun word-count nil
;;   "Count words in buffer"
;;   (interactive)
;;   (shell-command-on-region (point-min) (point-max) "wc -w"))


(defun unfill-paragraph ()
  (interactive)
  (let ((fill-column (point-max)))
    (fill-paragraph nil)))

(defun unfill-region (start end)
  (interactive "r")
  (let ((fill-column (point-max)))
    (fill-region start end nil)))


;; Courtesy of Evan Sultanik (http://www.sultanik.com/Word_count_in_Emacs)
;; quote: "I wrote a relatively simple (and equally lazy) Emacs Lisp function to
;;         calculate word length. It even strips LaTeX files of their commands!"
(defun word-count (&optional filename)
  "Returns the word count of the current buffer.  If `filename' is not nil, returns the word count of that file."
  (interactive)
  (save-some-buffers) ;; Make sure the current buffer is saved
  (let ((tempfile nil))
    (if (null filename)
        (progn
          (let ((buffer-file (buffer-file-name))
                (lcase-file (downcase (buffer-file-name))))
            (if (and (>= (length lcase-file) 4) (string= (substring lcase-file -4 nil) ".tex"))
                ;; This is a LaTeX document, so DeTeX it!
                (progn
                  (setq filename (make-temp-file "wordcount"))
                  (shell-command-to-string (concat "detex < " buffer-file " > " filename))
                  (setq tempfile t))
              (setq filename buffer-file)))))
    (let ((result (car (split-string (shell-command-to-string (concat "wc -w " filename)) " "))))
      (if tempfile
          (delete-file filename))
      (message (concat "Word Count: " result))
      )))


;; === edit file using sudo ===
;; à debugger
;; (defun sudo-edit (&optional arg)
;;   "Edit a file as root using sudo"
;;   (interactive "p")
;;   (if (or arg (not buffer-file-name))
;;       (find-file (concat "/sudo:root@localhost:" (ido-read-file-name "File: ")))
;;     (find-alternate-file (concat "/sudo:root@localhost:" buffer-file-name))))


;; === move to scratch buffer ===
(defun Nahra/go-to-scratch ()
  (interactive)
  (switch-to-buffer "*scratch*")
  (delete-other-windows))


;; Conversion des fins de lignes du format MS-DOS au format Unix
(defun dos2unix ()
  (interactive)
  (goto-char (point-min))
  (while (search-forward "\r" nil t)
    (replace-match "")))


;; Conversion des fins de ligne du format Unix au format MS-DOS
(defun unix2dos ()
  (interactive)
  (goto-char (point-min))
  (while (search-forward "\n" nil t)
    (replace-match "\r\n")))


;; Montrer la table des caractères ASCII étendus
;; Fonction fournie par Alex Schroeder <asc@bsiag.com>
(defun ascii-table ()
  "Afficher la table de caractères ASCII."
  (interactive)
  (switch-to-buffer "*ASCII*")
  (erase-buffer)
  (insert (format "Caractères ASCII de code 1 à 254.\n"))
  (let ((i 0))
    (while (< i 254) (setq i (+ i 1))
           (insert (format "%4d %c\n" i i))))
  (beginning-of-buffer))


;; insertion de la date courante
(defun Nahra-insere-date ()
  (;; interactive
   )
  (insert (calendar-date-string (calendar-current-date))))

;; insertion de la date sélectionnée dans le calendrier
;; le focus doit être dans le buffer où l'on insère
(defun Nahra-insere-date-sel ()
  (interactive)
  (when (and (boundp 'calendar-buffer)
             (buffer-live-p (get-buffer calendar-buffer))
             (let ((str
                    (with-current-buffer calendar-buffer
                      (calendar-date-string (calendar-cursor-to-date t)))))
               (insert str)))))


;; Insérer la date
(defun insert-date ()
  "Insert the current date and time at point."
  (interactive)
  (insert "============================================")
  (newline 1)
  (insert (current-time-string))
  (newline 1)
  (insert "--------------------------------------------")
  (newline 1))


;; lorem
(defun lorem ()
  "Insert a lorem ipsum."
  (interactive)
  (insert "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do "
          "eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad "
          "minim veniam, quis nostrud exercitation ullamco laboris nisi ut "
          "aliquip ex ea commodo consequat. Duis aute irure dolor in "
          "reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla "
          "pariatur. Excepteur sint occaecat cupidatat non proident, sunt in "
          "culpa qui officia deserunt mollit anim id est laborum."))


;; === google ===
(defun google (what)
  "Use google to search for WHAT."
  (interactive "sSearch: ")
  (w3m-browse-url (concat "http://www.google.de/search?q="
                          (w3m-url-encode-string what))))

(defun google-file (file)
  "Use google to search for a file named FILE."
  (interactive "sSearch for file: ")
  (w3m-browse-url
   (concat "http://www.google.de/search?q="
           (w3m-url-encode-string
            (concat "+intitle:\"index+of\" -inurl:htm -inurl:html -inurl:php "
                    file)))))

(defun google-message-id (message-id)
  "View MESSAGE-ID in Google Groups."
  (interactive
   (list (read-from-minibuffer "Message-ID: "
                               (let ((url (thing-at-point 'url)))
                                 (when (string-match "mailto:\\(.*\\)" url)
                                   (match-string 1 url))))))
  (when (string-match "<\\(.*\\)>" message-id)
    (setq message-id (match-string 1 message-id)))
  (w3m-browse-url (concat "http://www.google.de/groups?selm="
                          (w3m-url-encode-string message-id))))


;; === BOOKMARKS ===
;; searching using swish-e
(defvar Nahra/bookmarks-search-command
  "/usr/bin/swish-e"
  "Command used to search BOOKMARKS pages.")

(defvar Nahra/boomarks-search-index-file
  "/home/Nahra/.swish-e/bookmarks/netscape/index.swish-e"
  "Index used to search BOOKMARKS pages.")

(defun Nahra/bookmarks-search (query)
  "Search BOOKMARKS pages for QUERY."
  (interactive "sSearch query: ")
  (let ((command
         (format "%s -f %s -w %s -x '<swishdocpath>\n' -H 0 -s swishtitle"
                 Nahra/bookmarks-search-command
                 Nahra/boomarks-search-index-file
                 query)))
    (switch-to-buffer
     (get-buffer-create "*BOOKMARKS Search Results*"))
    (shell-command command (current-buffer))))

;; bookmaks editing
(defun Nahra/ffap-quick ()
  "Quickly open URL at point in background."
  (interactive)
  (ffap (ffap-guesser)))

(defun Nahra/find-bookmarks ()
  (interactive)
  (setq p1 (line-beginning-position))
  (setq p2 (line-end-position))
  (setq url (buffer-substring-no-properties p1 p2))
  (find-file url))

(defun insert-and-indent-line ()
  (interactive)
  (push-mark)
  (let*
      ((ipt (progn (back-to-indentation) (point)))
       (bol (progn (move-beginning-of-line 1) (point)))
       (indent (buffer-substring bol ipt)))
    (move-end-of-line 1)
    (newline)
    (insert indent)))

(defun Nahra/insert-link ()
  "Insert a link entry."
  (interactive)
  (when (eq major-mode 'sgml-mode)
    (insert-and-indent-line)
    (insert "<DT><A HREF=\"")
    (setq ins (point))
    (insert "\"></A>")
    (goto-char ins)))

(defun Nahra/insert-local-link ()
  "Insert 4 spaces and then a link entry."
  (interactive)
  (when (eq major-mode 'sgml-mode)
    (insert-and-indent-line)
    (insert "<DT><A HREF=\".\/")
    (setq ins (point))
    (insert "\/index.html\"></A>")
    (goto-char ins)))

(defun Nahra/insert-spaced-link ()
  "Insert 4 spaces and then a link entry."
  (interactive)
  (when (eq major-mode 'sgml-mode)
    (insert-and-indent-line)
    (insert "    <DT><A HREF=\"")
    (setq ins (point))
    (insert "\"></A>")
    (goto-char ins)))

(defun Nahra/insert-folder ()
  "Insert link entry inside a folder."
  (interactive)
  (when (eq major-mode 'sgml-mode)
    (insert-and-indent-line)
    (insert "<DT><H3>")
    (setq ins (point))
    (insert "</H3>")
    (insert-and-indent-line)
    (insert "<DL><p>")
    (insert-and-indent-line)
    (insert "    <DT><A HREF=\"")
    (insert "\"></A>")
    (insert-and-indent-line)
    (delete-backward-char 4)
    (insert "<\/DL><p>")
    (goto-char ins)))

(defun Nahra/insert-separator ()
  "Insert a separator."
  (interactive)
  (when (eq major-mode 'sgml-mode)
    (insert-and-indent-line)
    (insert "<HR>")))


;; ;; === html validating ===
(defun tidy-do ()
  "Run the HTML Tidy program on the current buffer."
  (interactive)
  (shell-command-on-region (point-min) (point-max)
                           (concat "tidy"
                                   " -m"
                                   " -config ~/.tidy.rc") t)
  ;; (delete-file "~/tmp/tidy/tidy-errors")
  (message "Buffer tidy'ed"))

;; ;; TODO Check that tidy is in PATH
;; ;; run in the buffer to be published
;; (eval-after-load "tidy"
;; '(progn (add-hook 'muse-after-publish-hook 'tidy-do)))


;; === lines ===
(defun move-line-down ()
  (interactive)
  (let ((col (current-column)))
    (save-excursion
      (next-line)
      (transpose-lines 1))
    (next-line)
    (move-to-column col)))

(defun move-line-up ()
  (interactive)
  (let ((col (current-column)))
    (save-excursion
      (next-line)
      (transpose-lines -1))
    (next-line)
    (move-to-column col)))


;; === Function to delete a line ===
;; First define a variable which will store the previous column position
(defvar previous-column nil "Save the column position")

;; Define the nuke-line function. The line is killed, then the newline
;; character is deleted. The column which the cursor was positioned at is then
;; restored. Because the kill-line function is used, the contents deleted can
;; be later restored by usibackward-delete-char-untabifyng the yank commands.
(defun nuke-line()
  "Kill an entire line, including the trailing newline character"
  (interactive)

  ;; Store the current column position, so it can later be restored for a more
  ;; natural feel to the deletion
  (setq previous-column (current-column))

  ;; Now move to the end of the current line
  (end-of-line)

  ;; Test the length of the line. If it is 0, there is no need for a
  ;; kill-line. All that happens in this case is that the new-line character
  ;; is deleted.
  (if (= (current-column) 0)
      (delete-char 1)

    ;; This is the 'else' clause. The current line being deleted is not zero
    ;; in length. First remove the line by moving to its start and then
    ;; killing, followed by deletion of the newline character, and then
    ;; finally restoration of the column position.
    (progn
      (beginning-of-line)
      (kill-line)
      (delete-char 1)
      (move-to-column previous-column))))
