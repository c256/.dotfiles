;;; my emacs keybindings

(provide 'y-keybindings)

;; special keymaps
(defvar ctl-z-map 	(make-sparse-keymap)	"Personalized keymap")

;; turn off a few things in multi-windowed environments
(if (fboundp 'window-system)
	(progn
	  (define-key ctl-x-map "\C-z" 'y-accidental-keystroke)
	  (global-set-key "\M-`" 'y-next-frame-or-buffer))) ;; No tmm

;; change to global keymap...
(global-set-key "\M-'"		 'what-line)
(global-set-key "\M-z"		 'undo)
;(global-set-key "\M-\C-r" 	 'query-replace)
(global-set-key [insertchar] 'overwrite-mode) ; for console use
;(global-set-key "\C-c\C-m" 	 'execute-extended-command)

;; perrsonal keymap
(global-set-key "\C-z" ctl-z-map)
(define-key ctl-z-map "\C-a"  "\C-u12\C-x^") ; enlarge window 12
(define-key ctl-z-map "\C-b"  'bury-buffer)
(define-key ctl-z-map "b"     'ibuffer)
(define-key ctl-z-map "\C-f"  'find-file-other-window)
(define-key ctl-z-map "\C-k"  'y-bury-and-delete)
(define-key ctl-z-map "\C-z"  'undo)
(define-key ctl-z-map "\C-l"  'goto-line-with-feedback)
(define-key ctl-z-map "\C-t"  'y-stamp); in y-hacks
(define-key ctl-z-map "g"     'goto-line-with-feedback)
(define-key ctl-z-map "t"     'y-tasklist)
(define-key ctl-z-map "j"     'webjump)

;; a few shortcuts
;(define-key ctl-x-map "\C-u"  'undo)
;(define-key ctl-x-map "\C-l"  'y-accidental-keystroke)
;(define-key ctl-x-map "\C-n"  'y-accidental-keystroke)

;; compilation
(define-key 	emacs-lisp-mode-map "\C-c\C-c" 	'save-and-byte-compile-buffer)
;(define-key 	latex-mode-map      "\C-c\C-c" 	'compile)

;; add Apropos to Help
(define-key help-map "A"	'apropos-command)
(define-key help-map "a"	'apropos)

;; shell
;; -- hook these into loading shell-mode
;(define-key shell-mode-map [M-up]   'comint-previous-input)
;(define-key shell-mode-map [M-down] 'comint-next-input)
