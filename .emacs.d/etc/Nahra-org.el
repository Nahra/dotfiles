(setq load-path (cons "~/.emacs.d/site-lisp/org" load-path))
(setq load-path (cons "~/.emacs.d/site-lisp/org-7.3/contrib/lisp" load-path))
(require 'org)


;; === encryption ===
;; (require 'org-crypt)
;; Encrypt all entries before saving
;; (org-crypt-use-before-save-magic)
;; (setq org-tags-exclude-from-inheritance (quote ("crypt")))
;; GPG key to use for encryption
;; (setq org-crypt-key "C49ED4D3")


;; === general settings ===
(autoload 'org-remember-annotation "org")
(autoload 'org-remember-handler "org")
(setq org-directory "~/emacs-datas/org")
(setq org-id-locations-file "~/emacs-datas/org/org-id-locations")
(setq org-default-notes-file (file-expand-wildcards "~/emacs-datas/org/Tasks/*.org"))
(setq org-publish-timestamp-directory "~/emacs-datas/org/.org-timestamps/")
;; (setq org-startup-indented t)
(setq remember-annotation-functions '(org-remember-annotation))
(setq remember-handler-functions '(org-remember-handler))
(setq org-hide-leading-stars nil)
(setq org-odd-levels-only nil)
(setq org-cycle-separator-lines 0)
(setq org-blank-before-new-entry (quote ((heading)
                                         (plain-list-item))))
(setq org-insert-heading-respect-content t)

;; Return Follows Links
(setq org-return-follows-link t)

;; Notes At The Top
(setq org-reverse-note-order nil)

;; Searching And Showing Results
(setq org-show-following-heading t)
(setq org-show-hierarchy-above t)
(setq org-show-siblings nil)

;; Editing And Special Key Handling
(setq org-special-ctrl-a/e t)
(setq org-special-ctrl-k t)
(setq org-yank-adjusted-subtrees t)

;; Attachments
(setq org-id-method (quote uuidgen))

;; Turn Off Prefer Future Dates
(setq org-read-date-prefer-future nil)

;; Deadlines And Agenda Visibility
(setq org-deadline-warning-days 30)

;; Automatically Change List Bullets
(setq org-list-demote-modify-bullet (quote (("+" . "-")
                                            ("*" . "-")
                                            ("1." . "-")
                                            ("1)" . "-"))))

;; disable special syntax for emphasized text
(setq org-emphasis-alist (quote (("*" bold "<b>" "</b>")
                                 ("/" italic "<i>" "</i>")
                                 ("_" underline "<span style=\"text-decoration:underline;\">" "</span>")
                                 ("=" org-code "<code>" "</code>" verbatim)
                                 ("~" org-verbatim "<code>" "</code>" verbatim))))

;; disable the priority setting keys
(setq org-enable-priority-commands nil)

;; Org mode can fold (cycle) plain lists. I don't use this feature.
(setq org-cycle-include-plain-lists nil)

;; I like to keep links in the same window so that I don't end up with a ton of frames in my window manager.
;; I normally work in a full-screen window and having links open in the same window just works better for me.
;; (setq org-link-frame-setup ((vm . vm-visit-folder)
;;                             (gnus . org-gnus-no-new-news)
;;                             (file . find-file-other-window)))


;; === hooks ===
;; Make TAB the yas trigger key in the org-mode-hook and enable flyspell mode and autofill
(add-hook 'org-mode-hook
          (lambda ()
            ;; flyspell mode for spell checking everywhere
            ;; (flyspell-mode 1)
            ;; auto-fill mode on
            ;; (auto-fill-mode 1)
            ;; yasnippet (cf org-mode manual, chap. 15)
            (make-variable-buffer-local 'yas/trigger-key)
            (org-set-local 'yas/trigger-key [tab])
            (define-key yas/keymap [tab] 'yas/next-field-group)))

;; === windmove ===
;; Make windmove work in org-mode:
;; (add-hook 'org-shiftup-final-hook 'windmove-up)
;; (add-hook 'org-shiftleft-final-hook 'windmove-left)
;; (add-hook 'org-shiftdown-final-hook 'windmove-down)
;; (add-hook 'org-shiftright-final-hook 'windmove-right)


;; === key bindings ===
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)


;; === diary ===
(setq org-agenda-include-diary nil)
(setq org-agenda-diary-file "~/emacs-datas/org/Tasks/diary.org")


;; === agenda ===
;; (setq org-agenda-files (quote ("~/emacs-datas/org/mobileorg/")))
;; add recursively every .org file to org-agenda-files
(setq org-agenda-files (find-lisp-find-files "~/emacs-datas/org" "\.org$"))
;; Include agenda archive files when searching for things
(setq org-agenda-text-search-extra-files (quote (agenda-archives)))
(setq org-agenda-custom-commands
      '(("f" occur-tree "test")
        ("w" todo "WAITING")))
(setq org-agenda-custom-commands
      (quote (("w" "Tasks waiting on something" tags "WAITING/!"
               ((org-use-tag-inheritance nil)
                (org-agenda-todo-ignore-scheduled nil)
                (org-agenda-todo-ignore-deadlines nil)
                (org-agenda-todo-ignore-with-date nil)
                (org-agenda-overriding-header "Waiting Tasks")))
              ("r" "Refile New Notes and Tasks" tags "LEVEL=1+REFILE"
               ((org-agenda-todo-ignore-with-date nil)
                (org-agenda-todo-ignore-deadlines nil)
                (org-agenda-todo-ignore-scheduled nil)
                (org-agenda-overriding-header "Tasks to Refile")))
              ("N" "Notes" tags "NOTE"
               ((org-agenda-overriding-header "Notes")))
              ("n" "Next" tags-todo "-WAITING-CANCELLED/!NEXT"
               ((org-agenda-overriding-header "Next Tasks")))
              ("p" "Projects" tags-todo "LEVEL=2-REFILE|LEVEL=1+REFILE/!-DONE-CANCELLED"
               ((org-agenda-skip-function 'Nahra/skip-non-projects)
                (org-agenda-overriding-header "Projects")))
              ("o" "Other (Non-Project) tasks" tags-todo "LEVEL=2-REFILE|LEVEL=1+REFILE/!-DONE-CANCELLED"
               ((org-agenda-skip-function 'Nahra/skip-projects)
                (org-agenda-overriding-header "Other Non-Project Tasks")))
              ("A" "Tasks to be Archived" tags "LEVEL=2-REFILE/DONE|CANCELLED"
               ((org-agenda-overriding-header "Tasks to Archive")))
              ("h" "Habits" tags "STYLE=\"habit\""
               ((org-agenda-todo-ignore-with-date nil)
                (org-agenda-todo-ignore-scheduled nil)
                (org-agenda-todo-ignore-deadlines nil)
                (org-agenda-overriding-header "Habits")))
              ("#" "Stuck Projects" tags-todo "LEVEL=2-REFILE|LEVEL=1+REFILE/!-DONE-CANCELLED"
               ((org-agenda-skip-function 'Nahra/skip-non-stuck-projects)
                (org-agenda-overriding-header "Stuck Projects")))
              ("c" "Select default clocking task" tags "LEVEL=2-REFILE"
               ((org-agenda-skip-function
                 '(org-agenda-skip-subtree-if 'notregexp "^\\*\\* Organization"))
                (org-agenda-overriding-header "Set default clocking task with C-u C-u I"))))))

(setq org-agenda-exporter-settings
      '((ps-number-of-columns 1)
        (ps-landscape-mode t)
        (org-agenda-add-entry-text-maxlines 5)
        (htmlize-output-type 'css)))

(setq org-agenda-ndays 1)


;; === agenda views ===
;; Show all future entries for repeating tasks
(setq org-agenda-repeating-timestamp-show-all t)

;; Show all agenda dates - even if they are empty
(setq org-agenda-show-all-dates t)

;; Start the weekly agenda today
(setq org-agenda-start-on-weekday nil)

;; Display tags farther right
(setq org-agenda-tags-column -110)

;; Disable display of the time grid
;; (setq org-agenda-time-grid
;;       (quote (nil "----------------"
;;                   (800 1000 1200 1400 1600 1800 2000))))

;; Sorting order for tasks on the agenda
(setq org-agenda-sorting-strategy
      (quote ((agenda user-defined-up habit-down time-up priority-down effort-up category-keep)
              (todo priority-down)
              (tags priority-down))))

;;
;; Agenda sorting functions
;;
(setq org-agenda-cmp-user-defined 'Nahra/agenda-sort)

(defmacro Nahra/agenda-sort-test (fn a b)
  "Test for agenda sort"
  `(cond
    ;; if both match leave them unsorted
    ((and (apply ,fn (list ,a))
          (apply ,fn (list ,b)))
     (setq result nil))
    ;; if a matches put a first
    ((apply ,fn (list ,a))
     ;; if b also matches leave unsorted
     (if (apply ,fn (list ,b))
         (setq result nil)
       (setq result -1)))
    ;; otherwise if b matches put b first
    ((apply ,fn (list ,b))
     (setq result 1))
    ;; if none match leave them unsorted
    (t nil)))

(defun Nahra/agenda-sort (a b)
  "Sorting strategy for agenda items.
  Late deadlines first, then scheduled, then non-late deadlines"
  (let (result)
    (cond
     ;; Holidays first
     ((Nahra/agenda-sort-test 'Nahra/is-holiday-today a b))

     ;; Anniversaries next
     ((Nahra/agenda-sort-test 'Nahra/is-anniv-today a b))

     ;; finally default to unsorted
     (t (setq result nil)))

    result))

(defun Nahra/is-holiday-today (date-str)
  (string-match "Holiday:" date-str))

(defun Nahra/is-anniv-today (date-str)
  (string-match "Anniv:" date-str))


;; === logging ===
(setq org-log-done (quote time))
(setq org-log-into-drawer t)

;; === todos ===
(setq org-enforce-todo-dependencies t)

(setq org-todo-keywords
      (quote ((sequence "TODO(t)" "NEXT(n)" "WAITING(w@/!)" "SOMEDAY(s!)" "|" "DONE(d!/!)" "CANCELLED(c@/!)")
              (sequence "QUOTE(Q!)" "QUOTED(D!)" "|" "APPROVED(A@)" "EXPIRED(E@)" "REJECTED(R@)")
              (sequence "OPEN(O)" "|" "CLOSED(C)"))))

(setq org-todo-keyword-faces
      (quote (("TODO"      :foreground "red"          :weight bold)
              ("NEXT"      :foreground "blue"         :weight bold)
              ("DONE"      :foreground "forest green" :weight bold)
              ("WAITING"   :foreground "yellow"       :weight bold)
              ("SOMEDAY"   :foreground "goldenrod"    :weight bold)
              ("CANCELLED" :foreground "forest green" :weight bold)
              ("QUOTE"     :foreground "hotpink"      :weight bold)
              ("QUOTED"    :foreground "indianred1"   :weight bold)
              ("APPROVED"  :foreground "forest green" :weight bold)
              ("EXPIRED"   :foreground "olivedrab1"   :weight bold)
              ("REJECTED"  :foreground "olivedrab"    :weight bold)
              ("OPEN"      :foreground "magenta"      :weight bold)
              ("CLOSED"    :foreground "forest green" :weight bold))))

(setq org-use-fast-todo-selection t)
(setq org-treat-S-cursor-todo-selection-as-state-change nil)

(setq org-todo-state-tags-triggers
      (quote (("CANCELLED"
               ("CANCELLED" . t))
              ("WAITING"
               ("WAITING" . t))
              ("SOMEDAY"
               ("WAITING" . t))
              (done
               ("WAITING"))
              ("TODO"
               ("WAITING")
               ("CANCELLED"))
              ("NEXT"
               ("WAITING"))
              ("DONE"
               ("WAITING")
               ("CANCELLED")))))

;; Keep tasks with dates off the global todo lists
(setq org-agenda-todo-ignore-with-date nil)

;; Allow deadlines which are due soon to appear on the global todo lists
(setq org-agenda-todo-ignore-deadlines (quote far))

;; Keep tasks scheduled in the future off the global todo lists
(setq org-agenda-todo-ignore-scheduled (quote future))

;; Remove completed deadline tasks from the agenda view
(setq org-agenda-skip-deadline-if-done t)

;; Remove completed scheduled tasks from the agenda view
(setq org-agenda-skip-scheduled-if-done t)

;; Remove completed items from search results
(setq org-agenda-skip-timestamp-if-done t)


;; === checklists ===
(require 'org-checklist)


;; === tags ===
(setq org-tags-column 65)
;; Tags with fast selection keys
(setq org-tag-alist (quote ((:startgroup)
                            ("@errand" . ?e)
                            ("@office" . ?o)
                            ("@home" . ?h)
                            (:endgroup)
                            ("PHONE" . ?P)
                            ("QUOTE" . ?q)
                            ("WAITING" . ?w)
                            ("HOME" . ?H)
                            ("ORG" . ?O)
                            ("crypt" . ?c)
                            ("MARK" . ?M)
                            ("NOTE" . ?n)
                            ("CANCELLED" . ?C))))

                                        ; Allow setting single tags without the menu
(setq org-fast-tag-selection-single-key (quote expert))

;; For tag searches ignore tasks with scheduled and deadline dates
(setq org-agenda-tags-todo-honor-ignore-options t)


;; === filtering ===
(defun Nahra/weekday-p ()
  (let ((wday (nth 6 (decode-time))))
    (and (< wday 6) (> wday 0))))

(defun Nahra/working-p ()
  (let ((hour (nth 2 (decode-time))))
    (and (Nahra/weekday-p) (or (and (>= hour 8) (<= hour 11))
                                (and (>= hour 13) (<= hour 16))))))

(defun Nahra/org-auto-exclude-function (tag)
  (and (cond
        ((string= tag "@home")
         (Nahra/working-p))
        ((string= tag "@office")
         (not (Nahra/working-p)))
        ((or (string= tag "@errand") (string= tag "phone"))
         (let ((hour (nth 2 (decode-time))))
           (or (< hour 8) (> hour 21)))))
       (concat "-" tag)))

(setq org-agenda-auto-exclude-function 'Nahra/org-auto-exclude-function)


;; === phone calls ===
;;
;; Phone capture template handling with BBDB lookup
;; modified from the original code by Gregory J. Grubbs
;;
(defvar gjg/capture-phone-record nil
  "Either BBDB record vector, or person's name as a string, or nil")

(defun Nahra/phone-call ()
  (interactive)
  (let* ((myname (completing-read "Who is calling? " (bbdb-hashtable) 'bbdb-completion-predicate 'confirm))
         (my-bbdb-name (if (> (length myname) 0) myname nil)))
    (setq gjg/capture-phone-record
          (if my-bbdb-name
              (first (or (bbdb-search (bbdb-records) my-bbdb-name nil nil)
                         (bbdb-search (bbdb-records) nil my-bbdb-name nil)))
            myname))
    (other-window 1)
    (let ((org-capture-templates '(("P" "Phone" entry (file "~/emacs-datas/org/Tasks/refile.org") "* TODO Phone %(gjg/bbdb-name) - %(gjg/bbdb-company)               :PHONE:\n  %U\n  %?" :clock-in t :clock-resume t))))
      (org-capture))))

(defun gjg/bbdb-name ()
  "Return full name of saved bbdb record, or empty string - for use in Capture templates"
  (if (and gjg/capture-phone-record (vectorp gjg/capture-phone-record))
      (concat "[[bbdb:"
              (bbdb-record-name gjg/capture-phone-record) "]["
              (bbdb-record-name gjg/capture-phone-record) "]]")
    "NAME"))

(defun gjg/bbdb-company ()
  "Return company of saved bbdb record, or empty string - for use in Capture templates"
  (if (and gjg/capture-phone-record (vectorp gjg/capture-phone-record))
      (or (bbdb-record-company gjg/capture-phone-record) "")
    "COMPANY"))


;; === projects ===
(defun Nahra/is-project-p ()
  "Any task with a todo keyword subtask"
  (let ((has-subtask)
        (subtree-end (save-excursion (org-end-of-subtree t))))
    (save-excursion
      (forward-line 1)
      (while (and (not has-subtask)
                  (< (point) subtree-end)
                  (re-search-forward "^\*+ " subtree-end t))
        (when (member (org-get-todo-state) org-todo-keywords-1)
          (setq has-subtask t))))
    has-subtask))

(defun Nahra/skip-non-stuck-projects ()
  "Skip trees that are not stuck projects"
  (let* ((subtree-end (save-excursion (org-end-of-subtree t)))
         (has-next (save-excursion
                     (forward-line 1)
                     (and (< (point) subtree-end)
                          (re-search-forward "^\\*+ NEXT " subtree-end t)))))
    (if (and (Nahra/is-project-p) (not has-next))
        nil ; a stuck project, has subtasks but no next task
      subtree-end)))

(defun Nahra/skip-non-projects ()
  "Skip trees that are not projects"
  (let* ((subtree-end (save-excursion (org-end-of-subtree t))))
    (if (Nahra/is-project-p)
        nil
      subtree-end)))

(defun Nahra/skip-projects ()
  "Skip trees that are projects"
  (let* ((subtree-end (save-excursion (org-end-of-subtree t))))
    (if (Nahra/is-project-p)
        subtree-end
      nil)))


;; === clocking ===
(setq org-clock-persist-file "~/emacs-datas/org/org-clock-save.el")
(defun Nahra/clock-in-to-next (kw)
  "Switch task from TODO to NEXT when clocking in.
Skips capture tasks and tasks with subtasks"
  (if (and (string-equal kw "TODO")
           (not (and (boundp 'org-capture-mode) org-capture-mode)))
      (let ((subtree-end (save-excursion (org-end-of-subtree t)))
            (has-subtask nil))
        (save-excursion
          (forward-line 1)
          (while (and (not has-subtask)
                      (< (point) subtree-end)
                      (re-search-forward "^\*+ " subtree-end t))
            (when (member (org-get-todo-state) org-not-done-keywords)
              (setq has-subtask t))))
        (when (not has-subtask)
          "NEXT"))))

;; Remove empty CLOCK drawers on clock out
(defun Nahra/remove-empty-drawer-on-clock-out ()
  (interactive)
  (save-excursion
    (beginning-of-line 0)
    (org-remove-empty-drawer-at "CLOCK" (point))))

(add-hook 'org-clock-out-hook 'Nahra/remove-empty-drawer-on-clock-out 'append)

;; Resume clocking tasks when emacs is restarted
(org-clock-persistence-insinuate)
;;
;; Yes it's long... but more is better ;)
(setq org-clock-history-length 28)
;; Resume clocking task on clock-in if the clock is open
(setq org-clock-in-resume t)
;; Change task state to NEXT when clocking in
(setq org-clock-in-switch-to-state (quote Nahra/clock-in-to-next))
;; Separate drawers for clocking and logs
(setq org-drawers (quote ("PROPERTIES" "LOGBOOK" "CLOCK")))
;; Save clock data in the CLOCK drawer and state changes and notes in the LOGBOOK drawer
(setq org-clock-into-drawer "CLOCK")
;; Sometimes I change tasks I'm clocking quickly - this removes clocked tasks with 0:00 duration
(setq org-clock-out-remove-zero-time-clocks t)
;; Agenda log mode items to display (clock time only by default)
(setq org-agenda-log-mode-items (quote (clock)))
;; Agenda clock report parameters (no links, 2 levels deep)
(setq org-agenda-clockreport-parameter-plist (quote (:link nil :maxlevel 2)))
;; Clock out when moving task to a done state
(setq org-clock-out-when-done t)
;; Save the running clock and all clock history when exiting Emacs, load it on startup
(setq org-clock-persist (quote history))
;; Enable auto clock resolution for finding open clocks
(setq org-clock-auto-clock-resolution (quote when-no-clock-is-running))
;; Include current clocking task in clock reports
(setq org-clock-report-include-clocking-task t)

(setq Nahra/keep-clock-running nil)

(defun Nahra/clock-in ()
  (interactive)
  (setq Nahra/keep-clock-running t)
  (if (marker-buffer org-clock-default-task)
      (unless (org-clock-is-active)
        (Nahra/clock-in-default-task))
    (unless (marker-buffer org-clock-default-task)
      (org-agenda nil "c"))))

(defun Nahra/clock-out ()
  (interactive)
  (setq Nahra/keep-clock-running nil)
  (when (org-clock-is-active)
    (org-clock-out)))

(defun Nahra/clock-in-default-task ()
  (save-excursion
    (org-with-point-at org-clock-default-task
      (org-clock-in))))

(defun Nahra/clock-out-maybe ()
  (when (and Nahra/keep-clock-running (not org-clock-clocking-in) (marker-buffer org-clock-default-task))
    (Nahra/clock-in-default-task)))

(add-hook 'org-clock-out-hook 'Nahra/clock-out-maybe 'append)

(require 'org-id)
(defun Nahra/clock-in-task-by-id (id)
  "Clock in a task by id"
  (save-restriction
    (widen)
    (org-with-point-at (org-id-find id 'marker)
      (org-clock-in nil))))

(defun Nahra/clock-in-last-task ()
  "Clock in the interrupted task if there is one"
  (interactive)
  (let ((clock-in-to-task (if (org-clock-is-active)
                              (setq clock-in-to-task (cadr org-clock-history))
                            (setq clock-in-to-task (car org-clock-history)))))
    (org-with-point-at clock-in-to-task
      (org-clock-in nil))))

(setq org-time-stamp-rounding-minutes (quote (1 15)))

;; clock reports
;; ; Set default column view headings: Task Effort Clock_Summary
(setq org-columns-default-format "%80ITEM(Task) %10Effort(Effort){:} %10CLOCKSUM")

                                        ; global Effort estimate values
(setq org-global-properties (quote (("Effort_ALL" . "0:10 0:30 1:00 2:00 3:00 4:00 5:00 6:00 7:00 8:00"))))


;; === refiling ===
(setq org-default-notes-file "~/emacs-datas/org/Tasks/refile.org")

;; 3 capture templates for TODO tasks, Notes, and org-protocol (untested)
(setq org-capture-templates (quote (("t" "todo" entry (file "~/emacs-datas/org/Tasks/refile.org") "* TODO %?
  %U
  %a" :clock-in t :clock-resume t)
                                    ("n" "note" entry (file "~/emacs-datas/org/Tasks/refile.org") "* %?                                                                            :NOTE:
  %U
  %a
  :CLOCK:
  :END:" :clock-in t :clock-resume t)
                                    ("w" "org-protocol" entry (file "~/emacs-datas/org/Tasks/refile.org") "* TODO Review %c
  %U" :immediate-finish t :clock-in t :clock-resume t))))

;; Use IDO for target completion
(setq org-completion-use-ido t)

;; Targets include this file and any file contributing to the agenda - up to 5 levels deep
(setq org-refile-targets (quote ((org-agenda-files :maxlevel . 5) (nil :maxlevel . 5))))

;; Targets start with the file name - allows creating level 1 tasks
(setq org-refile-use-outline-path (quote file))

;; Targets complete in steps so we start with filename, TAB shows the next level of targets etc
(setq org-outline-path-complete-in-steps t)

;; Allow refile to create parent tasks with confirmation
(setq org-refile-allow-creating-parent-nodes (quote confirm))

;; Use IDO only for buffers
;; set ido-mode to buffer and ido-everywhere to t via the customize interface
'(ido-mode (quote both) nil (ido))
'(ido-everywhere t)


;; === archiving ===
(setq org-archive-mark-done nil)


;; === reminders ===
;; Erase all reminders and rebuilt reminders for today from the agenda
(defun Nahra/org-agenda-to-appt ()
  (interactive)
  (setq appt-time-msg-list nil)
  (org-agenda-to-appt))

;; Rebuild the reminders everytime the agenda is displayed
(add-hook 'org-finalize-agenda-hook 'Nahra/org-agenda-to-appt)

;; This is at the end of my .emacs - so appointments are set up when Emacs starts
;; (Nahra/org-agenda-to-appt)

;; Activate appointments so we get notifications
(appt-activate t)

;; If we leave Emacs running overnight - reset the appointments one minute after midnight
(run-at-time "24:01" nil 'Nahra/org-agenda-to-appt);


;; === habits ===
;; Enable habit tracking (and a bunch of other modules)
(setq org-modules (quote (org-bbdb org-bibtex org-crypt org-gnus org-id org-info org-jsinfo org-habit org-inlinetask org-irc org-mew org-mhe org-protocol org-rmail org-vm org-wl org-w3m)))
;; global STYLE property values for completion
(setq org-global-properties (quote (("STYLE_ALL" . "habit"))))
;; position the habit graph on the agenda to the right of the default
(setq org-habit-graph-column 50)


;; === searching ===
;; (setq org-remove-highlights-with-change nil)


;; === babel ===
(require 'ob-ditaa)
(require 'ob-dot)
(require 'ob-R)

;; Do not prompt to confirm evaluation
;; This may be dangerous - make sure you understand the consequences
;; of setting this -- see the docstring for details
(setq org-confirm-babel-evaluate nil)

(setq org-babel-load-languages (quote ((clojure . t)
                                       (ditaa . t)
                                       (dot . t)
                                       (emacs-lisp . t)
                                       (gnuplot . t)
                                       (haskell . t)
                                       (latex . t)
                                       (ledger . t)
                                       (perl . t)
                                       (python . t)
                                       (R . t)
                                       (ruby . t)
                                       (sh . t))))

(setq org-ditaa-jar-path "/usr/share/java/ditaa/ditaa-0_9.jar")
;; (setq org-ditaa-jar-path "~/.emacs.d/site-lisp/org-7.3/contrib/scripts/ditaa.jar")

(add-hook 'org-babel-after-execute-hook 'org-display-inline-images)


;; === exporting ===
;; Exporting Tables To CSV
;; (setq org-table-export-default-format "orgtbl-to-csv")

(setq org-export-exclude-tags (list "EXCLUDE" "SENSITIVE"))
(setq org-export-select-tags (list "SELECT" "INCLUDE"))

;; experimenting with docbook exports - not finished
(setq org-export-docbook-xsl-fo-proc-command "fop %s %s")
(setq org-export-docbook-xslt-proc-command "xsltproc --output %s /usr/share/xml/docbook/xsl-stylesheets-1.76.1/fo/docbook.xsl %s")

;; on n'inclut aucune css par défaut
(setq org-export-html-style-include-default nil)

;; Export HTML Without XML Header
(setq org-export-html-xml-declaration (quote (("html" . "")
                                              ("was-html" . "<?xml version=\"1.0\" encoding=\"%s\"?>")
                                              ("php" . "<?php echo \"<?xml version=\\\"1.0\\\" encoding=\\\"%s\\\" ?>\"; ?>"))))

;; run tidy after having exported an html project
(add-hook 'org-export-html-final-hook 'tidy-do)

;; Export with LaTeX fragments
(setq org-export-with-LaTeX-fragments t)


;; === publishing ===
(require 'org-publish)

(setq org-publish-project-alist
      '(


        ;; These are the main web files
        ("org-www"
         :base-directory "~/emacs-datas/org/WWW"
         :base-extension "org"
         :publishing-directory "~/public_html/org/WWW"
         :publishing-function org-publish-org-to-html
         :headline-levels 3
         :recursive t
         :auto-preamble nil
         :auto-postamble nil
         :author nil
         ;; :postamble "</div>
         ;;             <div id=\"footer\">
         ;;             <div id=\"footer-inside\">
         ;;             <p id=\"copyright\">Copyright &copy; 2011 <a href=\"mailto:ch.leboucher@free.fr\">Christophe Leboucher</a>
         ;;             &mdash; Built in <a href=\"http://www.gnu.org/software/emacs/\">Emacs</a>
         ;;             with <a href=\"http://orgmode.org\">Org-mode</a>
         ;;             </p>
         ;;             <p id=\"validate\">
         ;;             <a href=\"http://validator.w3.org/check?uri=referer\">XHTML 1.0 | </a>
         ;;             <a href=\"http://jigsaw.w3.org/css-validator/check/referer?profile=css3\">CSS level 3</a>
         ;;             </p>
         ;;             </div>
         ;;             </div>
         ;;             </div>"
        :style-include-scripts nil
        :style-include-default nil
        :style "<meta name=\"robots\" content=\"noindex\">
                <link rel=\"stylesheet\" type=\"text/css\" href=\"/css/master.css\" />"
        ;; :style "<link rel=\"stylesheet\" type=\"text/css\" href=\"/org/Notes/css/org-notes.css\" />\n<link rel=\"stylesheet\" type=\"text/css\" href=\"http://yui.yahooapis.com/combo?3.0.0/build/cssreset/reset-min.css&amp;3.0.0/build/cssfonts/fonts-min.css\">"
        ;; :style "<link rel=\"stylesheet\" type=\"text/css\" href=\"/org/WWW/css/screen.css\" />\n<link rel=\"stylesheet\" type=\"text/css\" href=\"http://yui.yahooapis.com/combo?3.0.0/build/cssreset/reset-min.css&amp;3.0.0/build/cssfonts/fonts-min.css\">"
        ;; :style "<link rel=\"stylesheet\" type=\"text/css\" href=\"/org/WWW/css/master.css\" />"
        :auto-sitemap nil
        :sitemap-filename "pre-sitemap.org"
        :sitemap-ignore-case t
        :sitemap-sort-folders szdf
        ;; :makeindex t
        :exclude "includes/pre-sitemap.org\\|includes"
        )

        ;; images static files (jpg, pdf, etc)
        ("org-www-images"
         :base-directory "~/emacs-datas/org/WWW"
         :base-extension "png\\|jpg\\|gif\\|pdf"
         :publishing-directory "~/public_html/org/WWW"
         :recursive t
         :publishing-function org-publish-attachment
         )

        ;; css static files
        ("org-www-css"
         :base-directory "~/emacs-datas/org/WWW"
         :base-extension "css"
         :publishing-directory "~/public_html/org/WWW"
         :recursive t
         :publishing-function org-publish-attachment
         )

        ;; scripts static files (js)
        ("org-www-js"
         :base-directory "~/emacs-datas/org/WWW/javascript"
         :base-extension "js"
         :publishing-directory "~/public_html/org/WWW/javascript"
         :recursive t
         :publishing-function org-publish-attachment
         )

        ;; scripts static files (cgi)
        ("org-www-swish-e"
         :base-directory "~/emacs-datas/org/WWW/cgi-bin"
         :base-extension "cgi\\|swish-e\\|swish-e.prop"
         :publishing-directory "~/public_html/org/WWW/cgi-bin"
         :recursive t
         :publishing-function org-publish-attachment
         )

        ;; These are other static files (txt, etc)
        ("org-www-other"
         :base-directory "~/emacs-datas/org/WWW"
         :base-extension "txt\\|html" 
         :publishing-directory "~/public_html/org/WWW"
         :recursive t
         :publishing-function org-publish-attachment
         )

        ("www" :components ("org-www" "org-www-images" "org-www-css" "org-www-js" "org-www-swish-e" "org-www-other"))

        ;; These are the main web files
        ("org-notes"
         :base-directory "~/emacs-datas/org/Notes/"
         :base-extension "org"
         :publishing-directory "~/public_html/org/Notes"
         :publishing-function org-publish-org-to-html
         :headline-levels 3
         ;; :table-of-contents t
         ;; :section-numbers nil
         :recursive t
         ;; :auto-preamble t
         :style "<link rel=\"stylesheet\" type=\"text/css\" href=\"/css/org-notes.css\" />"
         ;; :style-include-default nil
         :auto-sitemap t
         :sitemap-filename "index.org"
         :sitemap-title "Notes"
         :sitemap-ignore-case t
         :sitemap-sort-folders szdf
         ;; :makeindex t
         :exclude "Private/*"
         )

        ;; These are static files (images, pdf, etc)
        ("org-notes-images"
         :base-directory "~/emacs-datas/org/Notes/"
         :base-extension "png\\|jpg\\|gif\\|pdf"
         :publishing-directory "~/public_html/org/Notes/"
         :recursive t
         :publishing-function org-publish-attachment
         )

        ;; css static files
        ("org-notes-css"
         :base-directory "~/emacs-datas/org/Notes/"
         :base-extension "css"
         :publishing-directory "~/public_html/org/Notes/"
         :recursive t
         :publishing-function org-publish-attachment
         )

        ;; scripts static files (js)
        ("org-notes-scripts"
         :base-directory "~/emacs-datas/org/Notes/"
         :base-extension "js"
         :publishing-directory "~/public_html/org/Notes/"
         :recursive t
         :publishing-function org-publish-attachment
         )

        ("notes" :components ("org-notes" "org-notes-images" "org-notes-css" "org-notes-scripts"))

        ;; These are the main web files
        ("org-tasks"
         :base-directory "~/emacs-datas/org/Tasks/"
         :base-extension "org"
         :publishing-directory "~/public_html/org/Tasks"
         :publishing-function org-publish-org-to-html
         :headline-levels 1
         :sub-superscript nil
         :tags nil
         :table-of-contents 1
         :recursive t
         :style "<link rel=\"stylesheet\" type=\"text/css\" href=\"/css/org-notes.css\" />"
         :auto-sitemap t
         :sitemap-filename "index.org"
         :sitemap-title "Tasks"
         :sitemap-ignore-case t
         :sitemap-sort-folders szdf
         :exclude "refile.org\\|from_iPhone.org"
         )

        ;; These are static files (images, pdf, etc)
        ("org-tasks-images"
         :base-directory "~/emacs-datas/org/Tasks/"
         :base-extension "png\\|jpeg\\|jpg\\|gif\\|pdf"
         :publishing-directory "~/public_html/org/Tasks/"
         :recursive t
         :publishing-function org-publish-attachment
         )

        ;; css static files
        ("org-tasks-css"
         :base-directory "~/emacs-datas/org/Tasks/"
         :base-extension "css"
         :publishing-directory "~/public_html/org/Tasks/"
         :recursive t
         :publishing-function org-publish-attachment
         )

        ;; scripts static files (js)
        ("org-tasks-scripts"
         :base-directory "~/emacs-datas/org/Tasks/"
         :base-extension "js"
         :publishing-directory "~/public_html/org/Tasks/"
         :recursive t
         :publishing-function org-publish-attachment
         )

        ("tasks" :components ("org-tasks" "org-tasks-images" "org-tasks-css" "org-tasks-scripts"))

        ;; These are the main web files
        ("org-theon"
         :base-directory "~/emacs-datas/org/MaxTheon/"
         :base-extension "org"
         :publishing-directory "~/public_html/org/MaxTheon"
         :publishing-function org-publish-org-to-latex
         :recursive t
         :style "<link rel=\"stylesheet\" type=\"text/css\" href=\"/css/org-notes.css\" />"
         :auto-sitemap t
         :sitemap-filename "index.org"
         :sitemap-title "Max Theon"
         :sitemap-ignore-case t
         :exclude "\\.org$"
         )

        ;; These are static files (images, pdf, etc)
        ("org-theon-images"
         :base-directory "~/emacs-datas/org/MaxTheon/"
         :base-extension "png\\|jpeg\\|jpg\\|gif\\|pdf"
         :publishing-directory "~/public_html/org/MaxTheon/"
         :recursive t
         :publishing-function org-publish-attachment
         )

        ;; css static files
        ("org-theon-css"
         :base-directory "~/emacs-datas/org/MaxTheon/"
         :base-extension "css"
         :publishing-directory "~/public_html/org/MaxTheon/"
         :recursive t
         :publishing-function org-publish-attachment
         )

        ;; scripts static files (js)
        ("org-theon-scripts"
         :base-directory "~/emacs-datas/org/MaxTheon/"
         :base-extension "js"
         :publishing-directory "~/public_html/org/MaxTheon/"
         :recursive t
         :publishing-function org-publish-attachment
         )

        ("theon" :components ("org-theon" "org-theon-images" "org-theon-css" "org-theon-scripts"))

        ("all" :components ("www" "notes" "tasks" "theon"))

        ))

(defun all-publish nil
  "Publish all."
  (interactive)
  (org-publish-all))


;; === personnal functions ===
;; Show todo items for this subtree
(defun Nahra/org-todo ()
  (interactive)
  (org-narrow-to-subtree)
  (org-show-todo-tree nil))

;; Widen
(defun Nahra/widen ()
  (interactive)
  (widen)
  (org-reveal))

;; Insert inactive timestamp
(defun Nahra/insert-inactive-timestamp ()
  (interactive)
  (org-insert-time-stamp nil t t nil nil nil))

;; It's bound to C-S-F12 so I just edit and hit C-S-F12 when I'm done and move on to the next thing
(defun Nahra/save-then-publish ()
  (interactive)
  (save-buffer)
  (org-save-all-org-buffers)
  (org-publish-current-project))


;; === Speed Commands ===
(setq org-use-speed-commands t)
(setq org-speed-commands-user (quote (("0" . delete-window)
                                      ("1" . delete-other-windows)
                                      ("2" . split-window-vertically)
                                      ("3" . split-window-horizontally)
                                      ("h" . hide-other)
                                      ("k" . org-kill-note-or-show-branches)
                                      ("r" . org-reveal)
                                      ("s" . org-save-all-org-buffers)
                                      ("z" . org-add-note))))


;; === mobileorg ===
;; sudo chown -R http:http /tmp/DAVLock/
;; sudo chmod 777 /tmp/DAVLock/
;; sudo chown -R Nahra:Nahra /home/Nahra/public_html/webdav/org/
;; sudo chmod -R 777 /home/Nahra/public_html/webdav/org/
(setq org-mobile-directory "~/public_html/webdav/org/")
(setq org-mobile-files (find-lisp-find-files "~/emacs-datas/org/" "\.org"))
(setq org-mobile-inbox-for-pull "~/emacs-datas/org/from_iPhone.org")


;; === gnus ===
(add-hook 'message-mode-hook 'orgstruct++-mode)


;; === anniversaires ===
(setq org-bbdb-anniversary-field 'anniversaire)


;; === custom faces ===
(custom-set-faces
 '(org-mode-line-clock ((t (:background "grey75" :foreground "red" :box (:line-width -1 :style released-button)))) t))


;; === miscellaneous ===
;; (setq org-log-done t
;;       org-todo-keywords '("URGENT" "AFAIRE" "CORRIGER" "ENVOYER" "DONE")
;;       org-todo-interpretation 'sequence)

;; Visiting Links
;; (setq org-link-frame-setup
;;       '((vm . vm-visit-folder-other-frame)
;;  (gnus . gnus)
;;  (file . find-file-other-window)))
