;;; keyval-mode.el --- Major mode for editing Source engine KeyValue files

;; Copyright (C) 2000, 2003 Scott Andrew Borton <scott@pp.htv.fi>
;; Copyright (C) 2014 Jacob Kragh <jhckragh@gmail.com>

;; This major mode was created by Jacob Kragh on 22 Aug 2014; it is a
;; MODIFIED version of wpdl-mode.el, which was created on 25 Sep 2000
;; by Scott Andrew Borton.

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 2
;; of the License, or (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program; if not, write to the Free Software
;; Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
;; 02110-1301, USA.

;;; Commentary:

;; Major mode for editing files written in the KeyValues format that
;; is used in Valve's Source engine. A description of this format can
;; be found here: https://developer.valvesoftware.com/wiki/KeyValues

;;; Code:

(defvar keyval-indent-offset 4)

(defvar keyval-mode-syntax-table
  (let ((table (make-syntax-table)))
    (modify-syntax-entry ?\" "\"" table)
    (modify-syntax-entry ?/ "< 12b" table)
    (modify-syntax-entry ?\n "> b" table)
    (modify-syntax-entry ?{ "(}" table)
    (modify-syntax-entry ?} "){" table)
    table)
  "Syntax table for keyval-mode")

; TODO: Rewrite this function
(defun keyval-indent-line ()
  "Indent current line as a KeyValue line"
  (beginning-of-line)
  (if (bobp)
      (indent-line-to 0)
    (let ((not-indented t) cur-indent)
      (if (looking-at "^[ \t]*}")
          (progn
            (save-excursion 
              (forward-line -1)
              (if (looking-at "^[ \t]*{")
                  (setq cur-indent (current-indentation))
                (setq cur-indent (- (current-indentation) keyval-indent-offset))))
            (if (< cur-indent 0)
                (setq cur-indent 0)))
        (save-excursion
          (while not-indented
            (forward-line -1)
            (cond ((looking-at "^[ \t]*}")
                   (progn
                     (setq cur-indent (current-indentation))
                     (setq not-indented nil)))
                  ((looking-at "^[ \t]*{")
                   (progn
                     (setq cur-indent (+ (current-indentation) keyval-indent-offset))
                     (setq not-indented nil)))
                  ((bobp) (setq not-indented nil))))))
      (if cur-indent
          (indent-line-to cur-indent)
        (indent-line-to 0)))))

(define-derived-mode keyval-mode prog-mode "KeyVal"
  "Major mode for editing Source KeyValue files"
  :syntax-table keyval-mode-syntax-table
  (setq font-lock-defaults '(nil nil nil))
  (setq-local indent-line-function #'keyval-indent-line)
  (setq-local comment-start "//")
  (setq-local comment-end "")
  (setq-local tab-width keyval-indent-offset)
  (setq-local indent-tabs-mode nil)
  (setq-local electric-indent-chars (cons '?  electric-indent-chars)))

(provide 'keyval-mode)
