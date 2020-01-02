; various extensions to MH-e
; $Header$

(provide 'y-mh-hacks)
(require `mh-e)

(autoload 'mh-nmail "mh-e" "Look at new mail in inbox folder")

(setq mh-insert-x-mailer nil
      mh-clean-message-header t
      mh-large-folder nil
      mh-show-use-goto-addr t)

; template for inserting mime parts
(defun mh-e-insert-mime ()
  "Insert the magic strings for mime parts at point.  Should be used
prior to `\C-c \C-e' (mh-edit-mhn).  You can revert from actual mime
parts back to magic string with `\C-c \C-m \C-u'."
  (interactive)
  (insert "#mime/type [description] /path/to/file\n")
  (message "Make sure this is on a line by itself, then hit '\C-c \C-e'")
  (sit-for 0))

(define-key mh-folder-mode-map "l" 'mh-pack-folder)
