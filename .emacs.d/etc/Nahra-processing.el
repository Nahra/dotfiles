;; processing-mode
;; (add-to-list 'load-path "/path/to/processing-emacs/")
(autoload 'processing-mode "processing-mode" "Processing mode" t)
(setq processing-location (concat (getenv "PROCESSING_HOME") "\\"))
