;; deal with the X11 interface
;; Currently includes very little, because I rarely use X11 right now.

(provide 'y-x11)
(require 'y-frame)

; Usefulness depends on the windowmanager in use.
;(setq server-visit-hook (append server-visit-hook '(raise-frame)))

;; window-system specific utility

(defun y-linux-open (file)
  "Use the system `xdg-open' command on FILE.
Errors are silently ignored."
  (interactive "f")
  (call-process "xdg-open" nil 0 nil 
				(expand-file-name file))) ;;; consider start-process instead

;;; System-specific mail sending setting here.
;;; Imported from macOS/iCloud, not updated.
;;
;; (setq
;;  send-mail-function 'smtpmail-send-it
;;  message-send-mail-function 'smtpmail-send-it
;;  user-mail-address "chadpbrown@me.com"
;;  user-full-name "Chad Brown"
;;  smtpmail-starttls-credentials '(("smtp.mail.me.com" 587 nil nil))
;;  smtpmail-auth-credentials  (expand-file-name "~/.authinfo")
;;  smtpmail-default-smtp-server "smtp.mail.me.com"
;;  smtpmail-smtp-server "smtp.mail.me.com"
;;  smtpmail-smtp-service 587
;;  smtpmail-debug-info t)

;; FIXME: Font changing with a cudgel, based on a very old set of
;; fonts.  Find a better way to do all of this.

; This one at least attempts to understand the difference between "for
; this frame" and "for all frames".
(defun font->Inconsolata-16 (all-frames)
  "Use the font Inconsolata (16 point)."
  (interactive "P")
  (set-frame-font "Inconsolata-16" 't (null all-frames)))

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
  "Use a large font."
  (interactive)
  (set-frame-font "-*-courier-medium-r-normal--34-*-*-*-m-*-*-*"))

(defun font->small ()
  "Use a small font."
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
  "Use Tahoma font.
%%TESTME -- may not work on X11."
  (interactive)
  (set-frame-font "Tahoma"))

(defun font->amtw ()
  "Use American Typewriter font.
%%TESTME -- may not work on X11."
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
