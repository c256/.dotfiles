;;; macintosh-word-cleanup.el
;;;
;;; Rel:v-1-58
;;;
;;; Copyright (C) 1997, 1998, 2000, 2004, 2007 Thien-Thi Nguyen
;;;
;;; This file is part of ttn's personal elisp library, released under
;;; the terms of the GNU General Public License as published by the
;;; Free Software Foundation; either version 3, or (at your option) any
;;; later version.  There is NO WARRANTY.  See file COPYING for details.

;;; Description: Replace Macintosh "Word" document crap w/ text.

;;;###autoload
(defun macintosh-word-cleanup ()
  "Replace Macintosh \"Word\" document crap w/ text."
  (interactive)
  (map-table-2col
   (lambda (from to)
     (message "looking at `%s' -> `%s'" from to)
     (goto-char 1)
     (while (search-forward from nil t)
       (replace-match to)))
   '("Ñ"  ""                         ; 8-pt italic
     "\C-m"  "\C-j"                     ; newline
     "’"  "i"                           ; i aigue
     "”"  "i"                        ; i ???
     "Ž"  "e"                        ; e aigue
     "Ð"  "-"                           ; n-dash
     "¦"  ""                         ; ???
     "—"  "a"                        ; a aigue
     "Ô"  "`"                           ; begin single quote
     "Õ"  "'"                           ; end single quote
     "©"  "(C)"                         ; copyright
     "Ã"  "?"                           ; question mark
     "Ò"  "<it>"                     ; italic on
     "Ó"  "</it>"                    ; italic off
     "\C-o"  "--"                       ; m-dash
     "ÿ"  "\C-j"                     ; newline + center
     "‰"  "e"                        ; e grave
     "¨"  ""                         ; 8-pt italic
     "‚"  "e"                        ; e aigue
     "Œ"  "i"                        ; i aigue
     ;; Add translations here.
     )))

(provide 'macintosh-word-cleanup)

;;; macintosh-word-cleanup.el ends here
