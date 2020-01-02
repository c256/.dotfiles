;; y-frame.el ;; 
;;
;; Frame-manipulation code for emacs 20+.  Start with a detached
;; minibuffer frame, and define convenience functions for adding new
;; frames.  To use the detached minibuffer, you need to load/require
;; this code at startup.

(provide 'y-frame)


;; Note on tool bar, menu bar, etc:

;; These things are also set in X resources, for speed and simplicty
;; If only set here, emacs will create/draw/whatnot them in system
;; startup, then remove them in user startup.  This can be annoying
;; with some WM's, and is generally wasteful.

;; external settings can be made to work under MacOSX using defaults.
;; Not doing that currently.

;; Tried it on the right to see if it gave a better sense of place for
;; large buffers.  Let's put it back and see how it feels.
;;(if window-system (set-scroll-bar-mode 'left))

(if y-detached-minibuffer
    (progn
      (message "Detached Minibuffer Selected.")
      (setq default-frame-alist (append default-frame-alist  ;; should be nil
					`((minibuffer . nil)
					 (name . "LeftEmacs")
					 (height . 66)
					 (width . 80)
;					 (menu-bar-lines . 0)
;					 (tool-bar-lines . 0)
;					 (vertical-scroll-bars . nil)
					 (horizontal-scroll-bars .
								       nil)
;					 (scroll-bar-width . 5)
;					 (left-fringe . 4)
;					 (right-fringe . 4)
					 (foreground-color . "NavajoWhite")
					 (background-color . "Black")
					 (cursor-color     . "Firebrick4")
					 )))
      (setq  initial-frame-alist '((minibuffer . nil)
				   (name . "LeftEmacs")
;				   (menu-bar-lines . 0)
;				   (tool-bar-lines . 0)
;				   (left-fringe . 4)
;				   (right-fringe . 4)
				   (scroll-bar-width . 5)
				   (height . 66)
				   (width . 80))))
  ;; else
  (progn
    (message "Attached Minibuffer Selected.")
    ;; I'm not worried about non-window-system choices at this point,
    ;; but I could handle it if it becomes an issue.  This means that
    ;; emacs -nw will try to use these colors.
    (setq default-frame-alist '((height . 66) 
				(width . 80)
				(top . 0)
				(left . 180)
				;(left-fringe . 5)
				;(right-fringe . 5)
				(foreground-color . "NavajoWhite")
				(background-color . "Black")
				(cursor-color     . "Firebrick4")))))
				      

; if we ever have a detached minibuffer, this tells us how it should look
(setq minibuffer-frame-alist (append minibuffer-frame-alist
				     '((minibuffer . only)
				      (height . 6)
				      (width . 57)
				      (top . -40)
				      (left . -5)
				      (name . "MiniBuffer")
;				      (font . "-*-lucidatypewriter-medium-*-*-*-12-*-*-*-m-*-*-*")
				      (menu-bar-lines . 0)
				      (auto-raise . t)
				      (tool-bar-lines . 0)
;				      (left-fringe . 4)
;				      (right-fringe . 4)
				      (vertical-scroll-bars . nil)
				      (horizontal-scroll-bars . nil)
				      (background-color . "Black")
				      (foreground-color . "#99b0ff")
				      (cursor-color .     "LightSkyBlue"))))


;; these names are keyed to xresources
(defun LeftEmacs () 
  "Create a new emacs frame with the name `LeftEmacs'."
  (interactive)
  (make-frame '((name . "LeftEmacs")
		(height . 66)
		(top . 0) ;; gets pushed below system menu bar
		(left . 120))))

(defun RightEmacs () 
  "Create a new emacs frame with the name 'RightEmacs'."
  (interactive)
  (make-frame '((name . "RightEmacs")
		(height . 66)
		(top . 0) ;; gets pushed below system menu bar
		(left . 1001))))

(defun write-room ()
  "Make a frame without any bling."
  (interactive)
  ;; to restore:
  ;; (setq mode-line-format (default-value 'mode-line-format))
  (let ((frame (make-frame '((vertical-scroll-bars . nil)
			     (left-fringe . 0); no fringe
			     (right-fringe . 0)
			     (border-width . 0)
			     (internal-border-width . 64); whitespace! 
			                                 ; want just left/right
			     (cursor-type . box)
			     (tool-bar-lines . 0)
			     (fullscreen . fullboth)  ; this doesn't work
			     (unsplittable . t)))))
    (select-frame frame)
;;    (find-file "~/NOTES")
    ;; maximize window if fullscreen above had no effect
    (when (fboundp 'w32-send-sys-command)
      (w32-send-sys-command 61488 frame))))


(defun SetColors ()
  "Manually (badly) specify the colors (for systems without color preferences)."
  (interactive)
  (set-background-color "Black")
  (set-foreground-color "NavajoWhite") 
  (set-cursor-color "Firebrick4"))

