(load-from-site-lisp "emms/lisp")

;;(require 'emms-setup)
;;(emms-devel)

(require 'emms)
(require 'emms-compat)
(require 'emms-player-simple)
(require 'emms-browser)
(require 'emms-cache)
(require 'emms-info)
;; (require 'emms-player-mplayer)
(require 'emms-player-mpd)
(require 'emms-playing-time)
(require 'emms-playlist-mode)
(require 'emms-streams)
(require 'emms-tag-editor)
(require 'emms-last-played)

(define-emms-simple-player my-mplayer '(file url)
  (concat "\\`\\(http\\|rtsp\\|mms\\)://\\|"
          (emms-player-simple-regexp
           "ogg" "mp3" "wav" "mpg" "mpeg" "wmv" "wma"
           "mov" "avi" "divx" "ogm" "ogv" "asf" "mkv"
           "rm" "rmvb" "mp4" "flac" "vob" "m4a" "ape"))
  "~/scripts/run-mp")

(define-emms-simple-player my-mplayer-playlist '(streamlist)
  "\\`http://"
  "~/scripts/run-stream")

(setq emms-player-list
      '(emms-player-my-mplayer
        emms-player-my-mplayer-playlist))

(emms-player-set emms-player-my-mplayer
                 'pause
                 'emms-player-my-mplayer-pause)

;;; Pause is also resume for mplayer
(emms-player-set emms-player-my-mplayer
                 'resume
                 nil)

(emms-player-set emms-player-my-mplayer
                 'seek
                 'emms-player-my-mplayer-seek)

(emms-player-set emms-player-my-mplayer
                 'seek-to
                 'emms-player-my-mplayer-seek-to)

(defun emms-player-my-mplayer-pause ()
  "Depends on mplayer's -slave mode."
  (process-send-string
   emms-player-simple-process-name "pause\n"))

(defun emms-player-my-mplayer-seek (sec)
  "Depends on mplayer's -slave mode."
  (process-send-string
   emms-player-simple-process-name
   (format "seek %d\n" sec)))

(defun emms-player-my-mplayer-seek-to (sec)
  "Depends on mplayer's -slave mode."
  (process-send-string
   emms-player-simple-process-name
   (format "seek %d 2\n" sec)))


(setq emms-playlist-buffer-name "*EMMS Playlist*"
      emms-directory "~/emacs-datas/emms"
      emms-cache-file "~/emacs-datas/emms/cache"
      emms-history-file "~/emacs-datas/emms/emms-history"
      emms-stream-bookmarks-file "~/emacs-datas/emms/streams"
      default-directory "~/MUSIQUE"
      emms-source-file-default-directory "~/emacs-datas/emms/Playlists/"
      emms-playing-time-style 'bar
      emms-info-asynchronously nil
      emms-stream-default-action "play"
      emms-show-format "%s")

(setq emms-last-played-format-alist
      '(((emms-last-played-seconds-today) . "%a %H:%M")
        (604800                           . "%a %H:%M") ; this week
        ((emms-last-played-seconds-month) . "%d")
        ((emms-last-played-seconds-year)  . "%m/%d")
        (t                                . "%Y/%m/%d")))


;; === keybindings locaux ===
(define-key emms-playlist-mode-map (kbd "x") 'emms-start)
(define-key emms-playlist-mode-map (kbd "v") 'emms-stop)
(define-key emms-playlist-mode-map (kbd "o") 'emms-show)

(define-key emms-playlist-mode-map (kbd "p") 'emms-pause)
(define-key emms-playlist-mode-map (kbd "N") 'emms-next)
(define-key emms-playlist-mode-map (kbd "P") 'emms-previous)
(define-key emms-playlist-mode-map (kbd ">") 'emms-cue-next)
(define-key emms-playlist-mode-map (kbd "<") 'emms-cue-previous)
(define-key emms-playlist-mode-map (kbd "SPC") 'emms-pause)

(define-key emms-playlist-mode-map (kbd "F") 'emms-streams)
(define-key emms-playlist-mode-map (kbd "C") 'emms-playlist-clear)
(define-key emms-playlist-mode-map (kbd "T") 'emms-add-directory-tree)
(define-key emms-playlist-mode-map (kbd "S") 'emms-playlist-save)
(define-key emms-playlist-mode-map (kbd "L") 'emms-play-playlist)

(define-key emms-playlist-mode-map (kbd "h") 'emms-shuffle)
(define-key emms-playlist-mode-map (kbd "r") 'emms-toggle-repeat-track)
(define-key emms-playlist-mode-map (kbd "R") 'emms-toggle-repeat-playlist)

(define-key emms-playlist-mode-map (kbd "E") 'emms-tag-editor-edit)

(define-key emms-playlist-mode-map (kbd "q") 'next-buffer) ; 'delete-window)


;; === miscellaneous ===
;; (eval-after-load "emms"
;;   '(progn

;;      (setq xwl-emms-playlist-last-track nil)
;;      (setq xwl-emms-playlist-last-indent "\\")

;;      (defun xwl-emms-track-description-function (track)
;;        "Return a description of the current track."
;;        (let* ((name (emms-track-name track))
;;               (type (emms-track-type track))
;;               (short-name (file-name-nondirectory name))
;;               (play-count (or (emms-track-get track 'play-count) 0))
;;               (last-played (or (emms-track-get track 'last-played) '(0 0 0)))
;;               (empty "..."))
;;          (prog1
;;              (case (emms-track-type track)
;;                ((file url)
;;                 (let* ((artist (or (emms-track-get track 'info-artist) empty))
;;                        (year (emms-track-get track 'info-year))
;;                        (playing-time (or (emms-track-get track 'info-playing-time) 0))
;;                        (min (/ playing-time 60))
;;                        (sec (% playing-time 60))
;;                        (album (or (emms-track-get track 'info-album) empty))
;;                        (tracknumber (emms-track-get track 'info-tracknumber))
;;                        (short-name (file-name-sans-extension
;;                                     (file-name-nondirectory name)))
;;                        (title (or (emms-track-get track 'info-title) short-name))

;;                        ;; last track
;;                        (ltrack xwl-emms-playlist-last-track)
;;                        (lartist (or (and ltrack (emms-track-get ltrack 'info-artist))
;;                                     empty))
;;                        (lalbum (or (and ltrack (emms-track-get ltrack 'info-album))
;;                                    empty))

;;                        (same-album-p (and (not (string= lalbum empty))
;;                                           (string= album lalbum))))
;;                   (format "%10s  %3d   %-20s%-60s%-35s%-15s%s"
;;                           (emms-last-played-format-date last-played)
;;                           play-count
;;                           artist

;;                           ;; Combine indention, tracknumber, title.
;;                           (concat
;;                            (if same-album-p ; indention by album
;;                                (setq xwl-emms-playlist-last-indent
;;                                      (concat " " xwl-emms-playlist-last-indent))
;;                              (setq xwl-emms-playlist-last-indent "\\")
;;                              "")
;;                            (if (and tracknumber ; tracknumber
;;                                     (not (zerop (string-to-number tracknumber))))
;;                                (format "%02d." (string-to-number tracknumber))
;;                              "")
;;                            title        ; title
;;                            )

;;                           ;; album
;;                           (cond ((string= album empty) empty)
;;                                 ;; (same-album-p "  ")
;;                                 (t (concat "《" album "》")))

;;                           (or year empty)
;;                           (if (or (> min 0)  (> sec 0))
;;                               (format "%02d:%02d" min sec)
;;                             empty))))
;;                ((url)
;;                 (concat (symbol-name type) ":" name))
;;                (t
;;                 (format "%-3d%s"
;;                         play-count
;;                         (concat (symbol-name type) ":" name))))
;;            (setq xwl-emms-playlist-last-track track))))

;;      (setq emms-track-description-function
;;            'xwl-emms-track-description-function)
;;      ))
