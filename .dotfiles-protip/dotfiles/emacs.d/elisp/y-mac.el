; deal with the Mac OS X native (Carbon) interface
; Currently includes very little macosx-specific stuff.

(provide 'y-mac)
(require 'y-frame)

;; Emacsify the macbookpro keyboard
;; These options effectively shadow standard macosx keys, including
;; some that I use, including Spotlight and Alfred. 
;(setq mac-command-modifier 'meta)
;(setq mac-option-modifier 'super)
(setq ns-command-modifier 'meta)
(setq ns-function-modifier 'hyper)

;; Many of these font settings are from old Linux/X11 systems, and
;; don't exist on modern computers. I should clean them out someday.

(defun font->lucida-8 ()
  "Use lucida typwriter 8pt font."
  (interactive)
  (set-frame-font "-*-lucida sans typewriter-medium-*-*-*-8-*-*-*-m-*-*-*"))

(defun font->lucida-10 ()
  "Use lucida typwriter 10pt font."
  (interactive)
  (set-frame-font "-*-lucida sans typewriter-medium-*-*-*-10-*-*-*-m-*-*-*"))

(defun font->lucida-12 ()
  "Use lucida typwriter 12pt font."
  (interactive)
  (set-frame-font "-*-lucida sans typewriter-medium-*-*-*-12-*-*-*-m-*-*-*"))

(defun font->lucida-14 ()
  "Use lucida typwriter 14pt font."
  (interactive)
  (set-frame-font "-*-lucida sans typewriter-medium-*-*-*-14-*-*-*-m-*-*-*"))

(defun font->courier-8 ()
  "Use courier 8pt font."
  (interactive)
  (set-frame-font "-*-courier-medium-*-*-*-8-*-*-*-m-*-*-*"))

(defun font->courier-10 ()
  "Use courier 10pt font."
  (interactive)
  (set-frame-font "-*-courier-medium-*-*-*-10-*-*-*-m-*-*-*"))

(defun font->courier-12 ()
  "Use courier 12pt font."
  (interactive)
  (set-frame-font "-*-courier-medium-*-*-*-12-*-*-*-m-*-*-*"))

(defun font->courier-15 ()
  "Use courier 15pt font."
  (interactive)
  (set-frame-font "-*-courier-medium-*-*-*-14-*-*-*-m-*-*-*"))

(defun font->large ()
  "Use large font."
  (interactive)
  (set-frame-font "-*-courier-medium-r-normal--34-*-*-*-m-*-*-*"))

(defun font->small ()
  "Use small font."
  (interactive)
  (set-frame-font "-*-courier-medium-r-normal--6-*-*-*-m-*-*-*"))

(defun font->6x10 ()
  "Use simple 6x10 font."
  (interactive)
  (set-frame-font "6x10"))

(defun font->5x8 ()
  "Use simple 5x8 font."
  (interactive)
  (set-frame-font "5x8"))

(defun font->schumacher-8 ()
  "Use Schumacher 8pt font."
  (interactive)
  (set-frame-font "-schumacher-clean-medium-r-normal--8-*-*-*-c-60-iso8859-1"))

(defun font->schumacher-10 ()
  "Use Schumacher 10pt font."
  (interactive)
  (set-frame-font "-schumacher-clean-medium-r-normal--10-*-*-*-c-60-iso8859-1"))

(defun font->schumacher-12 ()
  "Use Schumacher 12pt font."
  (interactive)
  (set-frame-font "-schumacher-clean-medium-r-normal--12-*-*-*-c-60-iso8859-1"))

(defun font->schumacher-14 ()
  "Use Schumacher 14pt font."
  (interactive)
  (set-frame-font "-schumacher-clean-medium-r-normal--14-*-*-*-*-*-iso8859-1"))

(defun font->schumacher-16 ()
  "Use Schumacher 16pt font."
  (interactive)
  (set-frame-font "-schumacher-clean-medium-r-normal--16-*-*-*-c-*-iso8859-1"))

(defun font->tahoma ()
  "Use Tahoma font on Mac OS X."
  (interactive)
  ;(set-frame-font "-apple-tahoma-medium-r-normal--0-0-0-0-m-0-mac-roman")
  (set-frame-font "Tahoma")) ;; variable-pitch fonts still have problems

(defun font->amtw ()
  "Use American Typewriter font on Mac OS X."
  (interactive)
  (set-frame-font "American Typewriter"))

(defun font->Hack ()
  "Use the font Hack."
  (interactive)
  (set-frame-font "Hack"))

(defun font->Anonymous ()
  "Use the font Anonymous."
  (interactive)
  (set-frame-font "Anonymous"))

(defun font->AnonymousPro ()
  "Use the font Anonymous Pro (14 point)."
  (interactive)
  (set-frame-font "Anonymous Pro-14"))

(defun font->AnonymousPro-16 ()
  "Use the font Anonymous Pro (16 point)."
  (interactive)
  (set-frame-font "Anonymous Pro-16"))

(defun font->AnonymousPro-22 ()
  "Use the font Anonymous Pro (22 point)."
  (interactive)
  (set-frame-font "Anonymous Pro-22"))

;; ------------------------------------------------------------------

;; testing from emacs-devel
(set-frame-parameter nil 'ns-transparent-titlebar t)

(defun y-macosx-open (file)
  "Use the system `open' command on FILE.
Errors are silently ignored."
  (interactive "f")
  (call-process "open" nil 0 nil 
				(expand-file-name file))) ;;; consider start-process instead

(defun y-macosx-open2 (file)
  "Use the shell to open FILE."
  (interactive "f")
  (shell-command (concat
				  (if (eq system-type 'darwin)
					  "open"
					(read-shell-command "Open file with: "))
				  " "
				  (expand-file-name file))))

(eval-after-load "dired"
  '(progn
     (define-key dired-mode-map (kbd "z")
       (lambda () (interactive)
         (let ((fn (dired-get-file-for-visit)))
           (start-process "default-app" nil "open" fn))))))

;; Help out dired via gnu ls
(setq insert-directory-program "gls")

;; Adjust scrolling for the macbook pro trackpad
(setq mouse-wheel-scroll-amount '(1 ((shift) . 5) ((control) . nil)))
(setq mouse-wheel-progressive-speed t)


;; ------------------------------------------------------------------
;; me.com (Apple iCloud) email settings

(setq
 send-mail-function 'smtpmail-send-it
 message-send-mail-function 'smtpmail-send-it
 user-mail-address "chadpbrown@me.com"
 user-full-name "Chad Brown"
 smtpmail-starttls-credentials '(("smtp.mail.me.com" 587 nil nil))
 smtpmail-auth-credentials  (expand-file-name "~/.authinfo")
 smtpmail-default-smtp-server "smtp.mail.me.com"
 smtpmail-smtp-server "smtp.mail.me.com"
 smtpmail-smtp-service 587
 smtpmail-debug-info t)

;; Remove these in favor of built-in TLS support
;;(setq 
;; starttls-extra-arguments nil
;; starttls-gnutls-program (executable-find "gnutls-cli")
;; smtpmail-warn-about-unknown-extensions t
;; starttls-use-gnutls t)
