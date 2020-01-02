;; y-frame.el ;; 
;;
;; Frame-manipulation code for emacs 20+.  Start with a detached
;; minibuffer frame, and define convenience functions for adding new
;; frames.  To use the detached minibuffer, you need to load/require
;; this code at startup.

(provide 'y-frame)

(defvar y-detached-minibuffer nil "Use a separate frame for the minibuffer.")

;; Note on tool bar, menu bar, etc:

;; These things are also set in X resources, for speed and simplicty.
;; If only set here, emacs will create/draw/whatnot them during system
;; startup, then remove them during user startup. This can be annoying
;; with some WM's, and is generally wasteful.

;; Some external settings can be made to work under macOS using
;; defaults. Can we use defaults to configure the macOS frame?
;; Not doing so currently.

;; Detacted minibuffer support, which hasn't been used for a while.
;; -- This shouldn't be setq'ing over existing settings!
;; -- Can we make this suck less under macOS?
(if y-detached-minibuffer
    (progn
      (message "Detached Minibuffer Selected.")
      (warn "This doesn't work well on macOS.")
      (setq default-frame-alist (append default-frame-alist  ;; should be nil
					`((minibuffer . nil))))
      (setq initial-frame-alist '((minibuffer . nil)
				  (name . "LeftEmacs")))
      ; if we ever have a detached minibuffer, this tells us how it
      ; should look. We blot style settings here, because we want the
      ; minibuffer frame to have a different style.
      (setq minibuffer-frame-alist (append minibuffer-frame-alist
					   '((minibuffer . only)
					     (height . 2)
					     (width . 66)
					     (top . -5) ; bottom edge
					     (left . -5) ; right side
					     (name . "MiniBuffer")
					     (font . "Inconsolata-14")
					     (auto-raise . t)
					     (tool-bar-lines . 0)
					     (vertical-scroll-bars . nil)
					     (horizontal-scroll-bars . nil)
					     (background-color . "Black")
					     (foreground-color . "#99b0ff")
					     (cursor-color .     "LightSkyBlue"))))))

;; Set the gui frame title
;; -- working on making this work in ns port, without killing the
;; -- ns-port's special title support (draggable icon, cascading file
;; -- name selection).
;; -- This isn't working yet.
;;(when window-system (setq frame-title-format'(buffer-file-name "%f" ("%b"))))

;; (when (window-system)
;;   (message "GUI frame setup.")
;; ;  (set-frame-font "Hack-16" nil t)
;;   (add-hook 'text-mode 'whitespace-mode)
;;   (add-hook 'prog-mode 'whitespace-mode) ; this isn't being inherited?
;;   ;; This doesn't work, because desktop/frame restoration clobbers it.
;;   (message "Growing mode-line font size.")
;;   (set-face-attribute 'mode-line nil
;;    		      :height 1.1
;;    		      :box '(:line-width 1
;;    			     :color "grey17"))
;;   (set-face-attribute 'mode-line-inactive nil
;;    		      :height 1.1
;;    		      :box nil))

;; these names were keyed to X resources. Make them work with macOS defaults?
(defun LeftEmacs ()
  "Create a new emacs frame with the name `LeftEmacs'."
  (interactive)
  (make-frame '((name . "LeftEmacs")
		(top . -0) ;; gets pushed below system menu bar
		(left . 79) ; matches the desktop
		(font . "Incosolata-16"))))

;; These settings don't work under macOS with the ns port.
;; They seemed to be possible with the mac port; figure out why.
(defun RightEmacs ()
  "Create a new emacs frame with the name 'RightEmacs'."
  (interactive)
  (make-frame '(;(name . "RightEmacs") ; names break the title bar
		(height . 62)
		(width . 80)
		(top . -0)
		(left . -200))))

;; Attempt at a distraction-free emacs window.

(defun SoloEmacs ()
  "Make a single large frame without any bling."
  (interactive)
  (make-frame '((name . "SoloEmacs")
		(tool-bar-lines . 0)
		(font . "Inconsolata-20")
		(vertical-scroll-bars . nil)
		(fullscreen . fullboth)	; Is this the right way?
		(alpha . 77))) 			; gives good result on macosx
  )

(defun FixColors ()
  "Manually (badly) specify the colors.
This is mostly useful for systems without color preferences or
themes, or for recovering from unreadable combinations."
  (interactive)
  (message "Called FixColors!")
  (set-background-color "Black")
  (set-foreground-color "NavajoWhite")
  (set-cursor-color "Firebrick4"))

;;; Fullscreen is sometimes nice, but for most things, what I want is
;;; a window as tall as possible.
;; (defun toggle-frame-fullheight ()
;;   "Toggle the current frame full-height.
;; Make the selected frame fullheight, or restore its previous state if it's already fullheight. Uses the same restore mechanism as `toggle-frame-fullsize'."
;;   (interactive)
;;   ;; Restore using the existing fullscreen/restore support.
;;   (let ((fullscreen (frame-parameter nil 'fullscreen)))
;;     (if (memq fullscreen '(fullscreen fullheight))
;; 		(let ((fullscreen-restore (frame-parameter nil 'fullscreen-restore)))
;; 		  (if (memq fullscreen-restore '(maximized fullheight fullwidth))
;; 			  (set-frame-parameter nil 'fullscreen fullscreen-restore)
;; 			(set-frame-parameter nil 'fullscreen nil)))
;;       (modify-frame-parameters
;; 	   nil `((fullscreen . fullheight)
;; 			 (fullscreen-restore . ,fullscreen))))))
;; ;; bind it
;; (define-key global-map [S-f11] 'toggle-frame-fullheight)

;; Settings for whitespace-mode
;; Adjust the faces for zenburn, especially whitespace-space.
(setq whitespace-style '(spaces tabs newline space-mark tab-mark newline-mark)
      whitespace-display-mappings
      ;; numbers are Unicode codepoint in decimal. e.g. (insert-char 182 1)
      '(
        (space-mark 32 [183] [46]) ; 32 space, 183 middle dot, 46 full stop
        (newline-mark 10 [182 10]) 	; 10 line feed
        (tab-mark 9 [8677 9] [92 9]) ; 9 tab, 8594 rightwards arrow
        ))

;; ·	 183	MIDDLE DOT
;; ¶	 182	PILCROW SIGN
;; ↵	8629	DOWNWARDS ARROW WITH CORNER LEFTWARDS
;; ↩	8617	LEFTWARDS ARROW WITH HOOK
;; ⏎	9166	RETURN SYMBOL
;; ▷	9655	WHITE RIGHT POINTING TRIANGLE
;; ▶	9654	BLACK RIGHT-POINTING TRIANGLE
;; →	8594	RIGHTWARDS ARROW
;; ↦	8614	RIGHTWARDS ARROW FROM BAR
;; ⇥	8677	RIGHTWARDS ARROW TO BAR
;; ⇨	8680	RIGHTWARDS WHITE ARROW

;; Adjusting the frame title along with tab-bar, from emacs-devel
;;(setq frame-title-format
;;      '("emacs --- "
;;        ((bound-and-true-p wconf-string) wconf-string)
;;        ((bound-and-true-p tab-bar-tab-name-function)
;;         (:eval (format "%d: %s"
;;                        (tab-bar--current-tab-index)
;;                        (funcall tab-bar-tab-name-function))))
;;        (multiple-frames " %b")         ;else too busy
;;        (global-mode-string             ;time, load, battery?
;;         (" " global-mode-string))
;;        " "))
