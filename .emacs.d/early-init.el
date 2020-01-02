;;; -*- lexical-binding: t; -*-

;; Turn off chrome early, to avoid redraw/flicker
(unless (or (eq window-system 'mac)
	    (eq window-system 'ns))
  (push '(menu-bar-lines . 0) default-frame-alist))
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)
(setq frame-inhibit-implied-resize t)
