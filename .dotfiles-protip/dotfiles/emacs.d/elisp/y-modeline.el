;; y-modeline.el ;; -*- emacs-lisp -*-
;; mode-line changes.

(provide 'y-modeline)

(setq solarized-high-contrast-mode-line t)

;; remove the length-12 formatting from the default value, "%12b".
(setq-default mode-line-buffer-identification 
			  (propertized-buffer-identification "%b"))
;; Why hide this?
;(setq-default mode-line-frame-identification '(""))       ; hide by default

;	      mode-line-modified '("%1+")                ; smaller

;; for some reason, this isn't working.  Old version just blasted the
;; hook, and does work.
;;(add-hook 'dired-mode-hook (lambda () ; unformat
;;			     (setq mode-line-buffer-indentification 
;;				   (propertized-buffer-identification "%b"))))

;;; Try the default for a bit.
(setq-default y-mode-line-format
      (list
;	   '(:eval (propertize " (%b)" 'face 'header-line
;						   'help-echo (buffer-file-name)))
	   " ("
       'mode-line-buffer-identification
       ") %@%Z"
;       'mode-line-mule-info
       'mode-line-modified
       'mode-line-frame-identification   ; in case something sets it
;;     ") ("
;;     'global-mode-string              ; dunno what uses this
       " %[("
       'mode-name
       'mode-line-process
       'minor-mode-alist
       "%n:"
       '(-3 . "%p")
       '(line-number-mode ":%l")
       '(column-number-mode "/%c")
       ")%] "
;; requires some imenu stuff I'm not using atm.
       '(which-function-mode
		 '(" <" which-func-format "> "))
       "(%f)"
       ""))

(setq dired-mode-hook (lambda ()
						(setq mode-line-buffer-identification
							  (propertized-buffer-identification "%b"))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq other-mlf '("%e"
				  mode-line-mule-info
				  mode-line-client
				  mode-line-modified
				  mode-line-remote

				  mode-line-frame-identification
				  mode-line-buffer-identification

				  mode-line-position

				  (vc-mode vc-mode)

				  mode-line-modes

				  (which-func-mode ("" which-func-format " "))

				  (global-mode-string ("" global-mode-string " "))))


