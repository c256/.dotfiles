;;; emacs init
;;; y@mit.edu

(setq debug-on-error 't) ; testing

;;(setq solarized-high-contrast-mode-line t)
;(package-initialize) ;; waiting to see how this falls out

;; Generic settings
(setq-default bidi-display-reordering nil)
(setq user-full-name "chad"
      user-mail-address "chadpbrown@gmail.com"
	  tab-width 4
      scroll-conservatively 101 ; magic value meaning 'never recenter'
      scroll-preserve-screen-position 'always
      auto-save-list-file-prefix 'nil
      x-stretch-cursor t
      inhibit-eol-conversion t
      compilation-scroll-output t
      window-min-height 4
      bookmark-save-flag t
      ispell-really-aspell t
      ispell-program-name "/usr/local/bin/aspell"
      dired-listing-switches "-alh"
	  ediff-window-setup-function 'ediff-setup-windows-plain
      custom-file (expand-file-name "~/.emacs.d/y-custom.el"))

;; Set paths (not Info or man, at present)
(add-to-list 'load-path (expand-file-name "~/.emacs.d/elisp"))
(add-to-list 'load-path "/usr/local/share/emacs/site-lisp" 'append)
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
(add-to-list 'exec-path "/usr/local/bin")
(add-to-list 'exec-path "/usr/local/sbin")
(add-to-list 'exec-path (expand-file-name "~/bin"))

;; load code
(require 'y-hacks)
;;; (require 'y-mh-hacks); not using MH anymore
(require 'y-frame)
(require 'y-modeline)
(if (eq (window-system) 'ns)
	(require 'y-mac))
(require 'y-keybindings) ;; last, so everything is properly defined

;; package manager support
;;

(add-to-list 'package-archives
			 '("marmalade" 	. "https://marmalade-repo.org/packages/") t)
;; not quite ready for https.
;(add-to-list 'package-archives
;			 '("Tom" 		. "http://tromey.com/elpa/") t)
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/") t)

;; These use a pair of functions in y-hacks.el to quietly
;; enable/disable modes if possible, and ignore any unknowns.
;; Look into replacing these with use-package directives.
(disable-quiet 'tool-bar-mode)
; (disable-quiet 'scroll-bar-mode)
(disable-quiet 'blink-cursor-mode)
(pcase (window-system)
  (`mac (enable-quiet 'menu-bar-mode)) ; since it's displayed by the OS
  (`ns  (enable-quiet 'menu-bar-mode)) ; ...in both of these...
  (_    (disable-quiet 'menu-bar-mode)))
(enable-quiet 'transient-mark-mode)
(enable-quiet 'show-paren-mode)
(enable-quiet 'temp-buffer-resize-mode)
(enable-quiet 'resize-minibuffer-mode)
(enable-quiet 'line-number-mode)
(disable-quiet 'column-number-mode) ; don't want it on normally
(enable-quiet 'auto-image-file-mode)
(enable-quiet 'global-font-lock-mode)
(enable-quiet 'minibuffer-electric-default-mode)
(enable-quiet 'file-name-shadow-mode) ; de-emphasize ignored text in minibuffer
(enable-quiet 'delete-selection-mode) ; typing replaces selection
;;(enable-quiet 'rich-minority-mode) ; clean up minor-mode indicators
(enable-quiet 'save-place)
(enable-quiet 'savehist-mode)
(enable-quiet 'recentf-mode)
(enable-quiet 'which-function-mode)
(enable-quiet 'icomplete-mode) ; incremental completion in the minibuffer
;(enable-quiet 'ido-mode) ; more complex completion mode
;(enable-quiet 'ido-everywhere)

;; Trying out use-package instead of my homegrown package support
;; infrastructure, such as it is.
;(use-package google-this
;			 :config
;			 (google-this-mode 1))

;; emacs `Customize' configuration support, done here to control
;; config loading order.
(load-file custom-file)

;; highlight unusual whitespace in buffers.
(setq-default show-trailing-whitespace t
			  indicate-empty-lines t)
; ...but not in the calendar, buffer list, or web browser
(add-hook 'calendar-mode-hook (lambda ()
								(setq-local show-trailing-whitespace nil)))
(add-hook 'Buffer-menu-mode-hook (lambda ()
								(setq-local show-trailing-whitespace nil)))
(add-hook 'eww-after-render-hook (lambda ()
								(setq-local show-trailing-whitespace nil)))

;; spell-check
(add-hook 'html-mode-hook    'turn-on-flyspell)
(add-hook 'text-mode-hook    'turn-on-flyspell)
(add-hook 'outline-mode-hook 'turn-on-flyspell) ; gets Org

;; auto-fill
(add-hook 'text-mode-hook    'turn-on-auto-fill)
(add-hook 'outline-mode-hook 'turn-on-auto-fill) ; gets Org

;; hl-line adds a subtle indicator to selector-style buffers
(add-hook 'dired-mode-hook        'hl-line-mode)
(add-hook 'package-menu-mode-hook 'hl-line-mode)
(add-hook 'Buffer-menu-mode-hook  'hl-line-mode)

;; eldoc provides constant feedback on elisp code
(add-hook 'emacs-lisp-mode-hook 'turn-on-eldoc-mode)

;; Super Meta-EX (adds fuzzy matching and DWIM)
(unless (not (fboundp 'smex))
  (global-set-key (kbd "M-x") 'smex)
  (global-set-key (kbd "M-X") 'smex-major-mode-commands)
  (global-set-key (kbd "C-c C-c M-x") 'execute-extended-command))

;; try out darkroom mode
;(with-eval-after-load 'darkroom
;  (setq darkroom-text-scale-increase 3)
;  (add-hook 'darkroom-mode-hook 'variable-pitch-mode))

;; Re-enable some potentially confusing features.
(put 'narrow-to-region 'disabled nil)  ;; leave bound
(put 'upcase-region 'disabled nil)     ;; unbound
; Enable minibuffer-using commands in the minibuffer.
(setq enable-recursive-minibuffer t)


;; %%FIXME: Figure out how to use Emacs' daemon mode while in macosx.
;; Daemon-mode inheirently includes `server-start'.
;; %%FIXME: Start the server unless we're in daemon mode
(server-start)

(message "Completed ~/.emacs")
