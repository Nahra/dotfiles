;; === localisation ===
(setq calendar-location-name "Caen, FR"
      calendar-latitude [49 10 north]
      calendar-longitude [00 22 west])


;; === format de date ===
;; date au format européen
(setq european-calendar-style t)

;; format de date français
(setq calendar-date-display-form '(dayname " " day " " monthname " " year))


;; === holidays ===
;; load/unload holidays
(setq mark-holidays-in-calendar t
      holiday-christian-holidays nil
      holiday-general-holidays nil
      holiday-hebrew-holidays nil
      holiday-islamic-holidays nil
      holiday-bahai-holidays nil
      holiday-oriental-holidays nil)

;; some extra holidays specific to country
(defun vacances (string sd sm sy ed em ey)
  "Compute holiday lists"
  (filter-visible-calendar-holidays
   (vacances-i string
               (calendar-absolute-from-gregorian (list sm sd sy))
               (calendar-absolute-from-gregorian (list em ed ey)))))

(defun vacances-i (string s e)
  "Holidays iterator"
  (if (= s e)
      nil
    (cons (list (calendar-gregorian-from-absolute s) string)
          (vacances-i string (+ s 1) e))))

(defun feries-paques ()
  "Liste des jours de vacances relatifs à paques."
  (let* ((century (1+ (/ displayed-year 100)))
         (shifted-epact ;; Age of moon for April 5...
          (% (+ 14 (* 11 (% displayed-year 19)) ;;     ...by Nicaean rule
                (- ;; ...corrected for the Gregorian century rule
                 (/ (* 3 century) 4))
                (/ ;; ...corrected for Metonic cycle inaccuracy.
                 (+ 5 (* 8 century)) 25)
                (* 30 century)) ;;              Keeps value positive.
             30))
         (adjusted-epact ;;  Adjust for 29.5 day month.
          (if (or (= shifted-epact 0)
                  (and (= shifted-epact 1) (< 10 (% displayed-year 19))))
              (1+ shifted-epact)
            shifted-epact))
         (paschal-moon ;; Day after the full moon on or after March 21.
          (- (calendar-absolute-from-gregorian (list 4 19 displayed-year))
             adjusted-epact))
         (abs-easter (calendar-dayname-on-or-before 0 (+ paschal-moon 7)))
         (day-list
          (list
           (list (calendar-gregorian-from-absolute abs-easter)
                 "Pâques")
           (list (calendar-gregorian-from-absolute (+ abs-easter 1))
                 "Lundi de Pâques")
           (list (calendar-gregorian-from-absolute (+ abs-easter 39))
                 "Jeudi de l'ascension")
           (list (calendar-gregorian-from-absolute (+ abs-easter 49))
                 "Pentecôte")
           (list (calendar-gregorian-from-absolute (+ abs-easter 50))
                 "Lundi de Pentecôte")))
         (output-list
          (filter-visible-calendar-holidays day-list)))
    output-list))

;; Les vacances françaises
;; (setq calendar-holidays
(setq holiday-other-holidays
      '((holiday-fixed 1 1 "Nouvel an")
        (holiday-fixed 5 1 "Fête du travail")
        (holiday-fixed 5 8 "Victoire 1945")
        (feries-paques)
        (holiday-fixed 7 14 "Fête nationale")
        (holiday-fixed 8 15 "Assomption")
        (holiday-fixed 11 11 "Armistice 1918")
        (holiday-fixed 11 1 "Toussaint")
        (holiday-fixed 12 25 "Noël")
        (holiday-float 5 0 2 "Fête des mères")
        (holiday-float 6 0 3 "Fête des pères")
        (holiday-float 3 0 -1 "Heure d'été")
        (holiday-float 10 0 -1 "Heure d'hiver")
        (vacances "Vacances de la Toussaint" 23 10 2010 4 11 2010)
        (vacances "Vacances de Noël" 18 12 2010 3 1 2011)
        (vacances "Vacances d'hiver" 26 2 2011 14 3 2011)
        (vacances "Vacances de printemps" 23 4 2011 9 5 2011)
        (vacances "Vacances d'été" 2 7 2011 5 9 2011)))


;; === faces ===
;; afficher le jour d'aujourd'hui
(setq today-visible-calendar-hook 'calendar-mark-today)
(setq calendar-today-marker 'calendar-today)

;; jours et mois en français
(setq calendar-day-name-array ["Dimanche" "Lundi" "Mardi" "Mercredi" "Jeudi" "Vendredi" "Samedi"]
      calendar-month-name-array ["Janvier" "Février" "Mars" "Avril" "Mai" "Juin" "Juillet" "Août" "Septembre" "Octobre" "Novembre" "Décembre"])


;; === misc ===
;; La semaine commence le lundi
(setq calendar-week-start-day 1)


(add-hook 'calendar-mode-hook (lambda () (setq show-trailing-whitespace nil)))
