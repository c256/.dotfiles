;; -*- mode: emacs-lisp -*-
;;
;; Bodged together for netbook and other devices without wc, pipes,
;; etc. I *think* based on an idea from Stefan Monier @emacs-devel.

(defun count-words (&optional syntax)
 "Count words in region if it exists, else in visible buffer.
What counts as a word depends on the syntax class, solicited by
prefix argument SYNTAX; the default is to use white space to
delimit words, like the shell command wc."
 (interactive "P")
 (let ((syn (if syntax (read-from-minibuffer "Syntax code: ") " "))
	(beg (if (mark t) (region-beginning) (point-min)))
	(end (if (mark t) (region-end) (point-max)))
	(count 0))
   (save-excursion
     (goto-char beg)
     ;; don't count initial white space
     (and (string= syn " ") (skip-syntax-forward syn)) 
     (while (< (point) end)
     	(skip-syntax-forward (concat "^" syn))
     	(unless (>= (point) end) (skip-syntax-forward syn))
	(setq count (1+ count))))
   (message "%d words in %s"
	     count (if (> (buffer-size) (- end beg)) "region" "buffer"))))
