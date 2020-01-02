;;; Set Emacs' environment to match the shell ;;; -*- mode: emacs-lisp -*-
;;;
;;; Doesn't work with my dotfiles; probably something assuming bash?

;(setenv-from-shell-environment "/bin/tcsh -ic")

(defun env-line-to-cons (env-line)
  "convert a string of the form \"VAR=VAL\" to a 
cons cell containing (\"VAR\" . \"VAL\")."
  (if (string-match "\\([^=]+\\)=\\(.*\\)" env-line)
    (cons (match-string 1 env-line) (match-string 2 env-line))))

(defun interactive-env-alist (&optional shell-cmd env-cmd)
  "launch /usr/bin/env or the equivalent from an interactive
shell, parsing and returning the environment as an alist."
  (let ((cmd (concat (or shell-cmd "/bin/bash -ic")
                     " "
                     (or env-cmd "/usr/bin/env"))))
    (mapcar 'env-line-to-cons
            (remove-if
             (lambda (str)
               (string-equal str ""))
             (split-string (shell-command-to-string cmd) "[\r\n]")))))

(defun setenv-from-cons (var-val)
  "set an environment variable from a cons cell containing 
two strings, where the car is the variable name and cdr is 
the value, e.g. (\"VAR\" . \"VAL\")"
  (setenv (car var-val) (cdr var-val)))

(defun setenv-from-shell-environment (&optional shell-cmd env-cmd)
  "apply the environment reported by `/usr/bin/env' (or env-cmd) 
as launched by `/bin/bash -ic' (or shell-cmd) to the current 
environment."
  (mapc 'setenv-from-cons (interactive-env-alist shell-cmd env-cmd)))


