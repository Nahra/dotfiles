;; git://github.com/jochu/clojure-mode.git
(add-to-list 'load-path (expand-file-name "~/.emacs.d/site-lisp/clojure-mode"))
;; git://github.com/jochu/swank-clojure.git
(add-to-list 'load-path (expand-file-name "~/.emacs.d/site-lisp/swank-clojure"))
;; git://git.boinkor.net/slime.git
(add-to-list 'load-path (expand-file-name "~/.emacs.d/site-lisp/slime"))


;; === paredit-mode ===
;; (autoload 'paredit-mode "paredit"
;;   "Minor mode for pseudo-structurally editing Lisp code."
;;   t)
;; (defun lisp-enable-paredit-hook () (paredit-mode 1))
;; (add-hook 'clojure-mode-hook 'lisp-enable-paredit-hook)


;; === clojure-mode ===
(require 'clojure-mode)
(defmacro defclojureface (name color desc &optional others)
  `(defface ,name
     '((((class color)) (:foreground ,color ,@others))) ,desc :group 'faces))

(defclojureface clojure-parens       "DimGrey"   "Clojure parens")
(defclojureface clojure-braces       "#49b2c7"   "Clojure braces")
(defclojureface clojure-brackets     "SteelBlue" "Clojure brackets")
(defclojureface clojure-keyword      "khaki"     "Clojure keywords")
(defclojureface clojure-namespace    "#c476f1"   "Clojure namespace")
(defclojureface clojure-java-call    "#4bcf68"   "Clojure Java calls")
(defclojureface clojure-special      "#b8bb00"   "Clojure special")
(defclojureface clojure-double-quote "#b8bb00"   "Clojure special"
  (:background "unspecified"))

(defun tweak-clojure-syntax ()
  (mapcar (lambda (x) (font-lock-add-keywords nil x))
          '((("#?['`]*(\\|)"                 . 'clojure-parens))
            (("#?\\^?{\\|}"                  . 'clojure-brackets))
            (("\\[\\|\\]"                    . 'clojure-braces))
            ((":\\w+"                        . 'clojure-keyword))
            (("#?\""               0 'clojure-double-quote prepend))
            (("nil\\|true\\|false\\|%[1-9]?" . 'clojure-special))
            (("(\\(\\.[^ \n)]*\\|[^ \n)]+\\.\\|new\\)\\([ )\n]\\|$\\)"
              1 'clojure-java-call))
            )))

(add-hook 'clojure-mode-hook 'tweak-clojure-syntax)
(add-hook 'slime-repl-mode-hook 'tweak-clojure-syntax)

(add-hook 'clojure-mode-hook 'turn-on-eldoc-mode)


;; === swank-clojure ===
(let
    ((clojure-jars (append
                    (when (file-directory-p "~/.clojure")
                      (directory-files "~/.clojure" t ".jar$"))
                    (when (file-directory-p "~/.clojure/ext")
                      (directory-files "~/.clojure/ext" t ".jar$")))))
  (setq swank-clojure-jar-path (expand-file-name "~/.clojure/clojure.jar")
        swank-clojure-classpath clojure-jars
        swank-clojure-extra-classpaths clojure-jars))
(require 'swank-clojure)


;; === slime ===
(eval-after-load "slime"
  '(progn
     (add-to-list 'slime-lisp-implementations '(sbcl ("sbcl")))
     (slime-setup '(slime-repl))))
(load (expand-file-name "~/.emacs.d/site-lisp/slime/slime-autoloads.el"))
