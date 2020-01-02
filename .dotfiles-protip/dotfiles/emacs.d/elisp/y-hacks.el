;; y-hacks.el
;;
;; a bunch of customization/hacks for emacs, in no particular order

(provide 'y-hacks)

;; convenience macros
(fset 'y-kill-buffer! "\C-xk") ;; doesn't ask
(fset 'y-enlarge-window "\C-u12\C-x^")	;; grow window by a largish amount
(fset 'make  'compile)
(fset 'gmake 'compile) ;; built into my fingers

;; don't try to page inside Emacs
(setenv "PAGER" "/bin/cat")

(defun clear-kill-ring ()
  "Clear the kill ring and garbage collect."
  (interactive)
  (setq kill-ring '()) ;; check mouse-selection functions
                       ;; if they're ok, set the kill ring to include
                       ;; something like `kill ring cleared on <date>'
                       ;; after clearing.
  (garbage-collect))

(defun y-stamp ()
  "Insert customized user/date/timestamp at point.
Uses time-stamp.el (without asking)."
  (interactive)
  (require 'time-stamp)
  (if (fboundp 'time-stamp-string)
	  (insert (time-stamp-string "\[%u:%:y/%02m/%02d-%02H:%02M:%02S-%Z\]"))
	(error "Couldn't find time-stamp-string.")))

;; consider replacing this with Org functionality.
(defun add-to-collection ()
  "Add text between point and mark to collection file, using helper script."
  (interactive)
  (defvar y-add-command (expand-file-name "~/bin/add-to-collection"))
  ;; for now, be stupid and assume collection is already terminated.
  (shell-command-on-region (point) (mark) y-add-command))

(defun enable-quiet (func)
  "IFF this version of emacs knows about FUNC, enable it."
  (if (fboundp func)
      (apply func '(1))))

(defun disable-quiet (func)
  "IFF this version of emacs knows about FUNC, disable it."
  (if (fboundp func)
      (apply func '(-1))))

(defun save-and-byte-compile-buffer (&optional file)
  "Simple function to save a bufer and then byte-compile it."
  (interactive "p")
  (save-buffer file)
  (byte-compile-file (buffer-file-name)))

(defun y-accidental-keystroke ()
  "Used to let me know when I've hit a key that I've rebound FROM
something annoying but not rebound TO, yet."
  (interactive)
  (error "You hit a key you didn't mean to hit!"))

(defun y-tasklist ()
  "Load my task list."
  (interactive)
  (find-file (expand-file-name "~/CNotes/todo.txt")))

;; Still useful?
(defun mail->ymit ()
  "Configure mail setup to be `from' y@mit.edu."
  (interactive)
  (setq user-mail-address "y@mit.edu"))

;; -- does this hapen anymore?
;; -- I suspect it was an artifact of an old setup.
(defun y-workaround-cx50 ()
  "Apply workaround for bug that binds `C-x 5 0' to
  handle-delete-frame instead of delete-frame."
  (interactive)
  (global-set-key [delete-frame] nil))

(defun y-make-org ()
  "Make the current buffer use org-mode, for now and the future."
  (interactive)
  (save-excursion
    (add-file-local-variable-prop-line 'mode 'org)
    (org-mode)))

;;; from Stefan Monnier <monnier@iro.umontreal.ca>
(defun unfill-paragraph ()
  "Takes a multi-line paragraph and makes it into a single line of text."
  (interactive)
  (let ((fill-column (point-max)))
	(fill-paragraph nil)))
;; Handy key definition
(define-key global-map "\M-Q" 'unfill-paragraph)

;;; support for auto-byte-compiling emacs-lisp. From Xah Lee.
(defun byte-compile-current-buffer ()
  "Run `byte-compile' on the current buffer if it is
  emacs-lisp-mode and a compiled file exists. Meant to be used in
  a hook like after-save-hook."
  (interactive)
  (when (and (eq major-mode 'emacs-lisp-mode) 
			 (file-exists-p (byte-compile-dest-file buffer-file-name)))
	(byte-compile-file buffer-file-name)))

;; not sure about this yet. If I do it, it shouldn't be done here.
;;(add-hook 'after-save-hook 'byte-compile-current-buffer)

(if (not (boundp 'turn-on-hl-line))
	(defun turn-on-hl-line () 
	  "Unconditionally enable highlight-line mode."
	  (hl-line-mode 1)))

;; Show line numbers, then goto-line. We could use this always instead
;; of goto-line (which is a user-level command, so it should be safe
;; from elisp calls), with something like:
;;   (global-set-key [remap goto-line] 'goto-line-with-feedback)
;;
;; Since I often want to goto-line somewhere not visible in the
;; current window, I'm trying it out (via custom keybindings) for now.
(defun goto-line-with-feedback ()
  "Show line numbers temporarily, while prompting for the line number input"
  (interactive)
  (autoload-do-load nlinum-mode) ;; need it loaded to check the status
                                ;; there's probably a better way
  (let ((y--linum-status (unless nlinum-mode -1))) ;; need -1 to force off
	(unwind-protect
		(progn
		  (nlinum-mode 1)
		  (call-interactively 'goto-line))
	  (nlinum-mode y--linum-status))))

;;; DWIM convenience function for M-`
(defun y-next-frame-or-buffer ()
  "Switch to the next frame, or if there is only one frame, the
next buffer in this frame."
  (interactive)
  (if (cdr (frame-list))
	  (other-frame 1)
	(bury-buffer)))

;;; eshell commands
(defun y-em/clean (&optional dir)
  "Invoke dired on DIR (or current directory, mark backups for deletion,
and delete any files so marked."
  (save-excursion
	(dired ".")
	(revert-buffer)
	(if (dired-flag-backup-files)
		(dired-do-flagged-delete 't))))


;;; alternative efficient y-kill-buffer, from irreal.org
(defun jcs-kill-a-buffer (askp)
  (interactive "P")
  (if askp
      (kill-buffer (funcall completing-read-function
                            "Kill buffer: "
                            (mapcar #'buffer-name (buffer-list))))
    (kill-this-buffer)))

;; (global-set-key (kbd "C-x k") 'jcs-kill-a-buffer)

