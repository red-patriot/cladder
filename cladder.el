;;; cpp-class.el --- Autogenerate C++ class headers

;; copyright (C) 2019 Bryson Tanner

;; Author: Bryson Tanner <realredpatriot@gmail.com>
;; Package-Requires: ((emacs "24"))
;; Version: 0.1.0

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;;; Code:

(defun add-declaration(name parent)
  "Insert the class declaration at the current cursor position.

NAME is name of classto eb declared.
PARENT is name of superclass of the class."
  (insert "class " name)
  (when (not (string-equal parent "__none"))
	(insert " : public " parent))
  (insert " {\npublic:\n")
  (insert "\t" name "();\n")
  (insert "\t~" name "();\n")
  (insert "\n};")
  )

(defun add-definition(name)
  "Insert the class declaration at the current cursor position.

NAME is the name of the class to be defined."
  (insert name "::" name "()\n{\n\n}")
  (insert name "::~" name "()\n{\n\n}")
  )

(defun add-class ()
  "Add a C++ class at the current cursor position."
  (interactive)
  (let (class-name class-parent)
	(setq class-name (read-string "Class name: "))
	(setq class-parent (read-string "Parent class(default=none): " nil nil "__none"))
	(if (y-or-n-p "Add class in new file? ")
		(setq  class-file (read-file-name "Location: "))
	  ;; create a new header file and move to it
	  (setq headerBuf (generate-new-buffer (concat class-name ".h")))
	  (set-buffer headerBuf)
	  )
	(add-declaration class-name class-parent)
	)
  )
	
(provide 'add-class)
;;; cpp-class.el ends here
