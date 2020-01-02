(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#3C3836" "#FB4934" "#B8BB26" "#FABD2F" "#83A598" "#D3869B" "#8EC07C" "#EBDBB2"])
 '(backup-by-copying-when-linked t)
 '(confirm-kill-emacs #'yes-or-no-p)
 '(custom-enabled-themes '(flatui-dark))
 '(custom-safe-themes
   '("6383f86cac149fb10fc5a2bac6e0f7985d9af413c4be356cab4bfea3c08f3b42" "596a1db81357b93bd1ae17bed428d0021d12f30cda7bbb31ac44e115039171ae" "5ecdec97d6697c14c9cbbd634ac93979d199e3f65b7d60d2c2c357bcb40e2821" "c626e064e512724d0c5ec0f802243fe2f0a4223373df8bb89c1f70ce904c135c" "a69efc0b576b75d848a55169ffee7429b118ce24779dc638c428b0025d964e26" default))
 '(desktop-path '("~/.emacs.d/"))
 '(desktop-restore-frames t)
 '(desktop-restore-in-current-display t)
 '(desktop-save-mode t)
 '(eshell-ask-to-save-history 'always)
 '(eshell-history-size 1024)
 '(eshell-pushd-dextract t)
 '(eshell-pushd-tohome t)
 '(eshell-rm-interactive-query t)
 '(eval-expression-print-length nil)
 '(eval-expression-print-level nil)
 '(fci-rule-color "#383838")
 '(frame-maximization-mode 'fullscreen)
 '(ido-save-directory-list-file "~/.emacs.d/ido.last")
 '(indicate-buffer-boundaries 'right)
 '(indicate-empty-lines t)
 '(locate-command "mdfind")
 '(ns-function-modifier 'hyper)
 '(org-startup-folded 'content)
 '(package-selected-packages
   '(all-the-icons hydra which-key graphviz-dot-mode flatui-dark-theme visual-regexp pinentry google-this use-package org smex beacon markdown-mode sx adaptive-wrap darkroom dash debbugs ioccur nlinum paredit))
 '(pos-tip-background-color "#36473A")
 '(pos-tip-foreground-color "#FFFFC8")
 '(recentf-exclude '(".Private/"))
 '(recentf-save-file "~/.emacs.d/recentf")
 '(save-place-file "~/.emacs.d/.emacs-places")
 '(save-place-ignore-files-regexp
   "\\(?:COMMIT_EDITMSG\\|hg-editor-[[:alnum:]]+\\.txt\\|svn-commit\\.tmp\\|bzr_log\\.[[:alnum:]]+\\|\\.Private\\)$")
 '(save-place-mode t nil (saveplace))
 '(sentence-end-double-space nil)
 '(shell-popd-regexp "bd")
 '(shell-pushd-dextract t)
 '(shell-pushd-regexp "cd")
 '(shell-pushd-tohome t)
 '(smex-save-file "~/.emacs.d/smex-items")
 '(tab-width 4)
 '(tool-bar-mode nil)
 '(track-eol t)
 '(uniquify-buffer-name-style 'post-forward-angle-brackets nil (uniquify))
 '(vc-annotate-background "#2B2B2B")
 '(vc-annotate-color-map
   '((20 . "#BC8383")
	 (40 . "#CC9393")
	 (60 . "#DFAF8F")
	 (80 . "#D0BF8F")
	 (100 . "#E0CF9F")
	 (120 . "#F0DFAF")
	 (140 . "#5F7F5F")
	 (160 . "#7F9F7F")
	 (180 . "#8FB28F")
	 (200 . "#9FC59F")
	 (220 . "#AFD8AF")
	 (240 . "#BFEBBF")
	 (260 . "#93E0E3")
	 (280 . "#6CA0A3")
	 (300 . "#7CB8BB")
	 (320 . "#8CD0D3")
	 (340 . "#94BFF3")
	 (360 . "#DC8CC3")))
 '(vc-annotate-very-old-color "#DC8CC3")
 '(which-function-mode t))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(eshell-prompt ((t (:foreground "SteelBlue2" :weight bold)))))

;;; Removed for testing
;;;  '(mode-line ((t (:background "#2B2B2B" :foreground "#8FB28F" :box (:line-width -1 :style released-button) :height 1.2))))
;;; '(mode-line-inactive ((t (:background "#383838" :foreground "#5F7F5F" :box (:line-width -1 :style released-button) :height 1.2))))
