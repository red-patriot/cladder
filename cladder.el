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

(defun add-class()
	"Interactively add a new class.

The language is autodetected from the current major mode."
	(interactive)
	(if (derived-mode-p 'prog-mode)
			;; Detect programming language from major mode
			(progn
				(when (string-equal major-mode "c++-mode") (add-cpp-class))
				(when (string-equal major-mode "emacs-lisp-mode") (unsupported "Emacs Lisp"))
				;; TODO: Add support for more lanugages
				)
		;; Inform the user if classes cannot be added.
		(progn
			(message "You can only add a class when you are in a programming mode.")
			)
		)
	)

(defun add-cpp-class()
  "Add a new C++ class."
	;; Ask the user which style of class will be added and where.
  (if (y-or-n-p "Create inline class? ")
			(progn
				(if (y-or-n-p "Add class in new file? ")
						(progn
							(create-inline-cpp-class-in-new-file)
							)
					(progn
						(create-inline-cpp-class-here)
						)
					)
				)
		(progn
			(if (y-or-n-p "Add class in new file? ")
					(progn
						(create-cpp-class-in-new-file)
						)
				(progn
					(create-cpp-class-here)
					)
				)
			)
		)
  )

(defun create-inline-cpp-class-in-new-file()
  "Create an inline class in a new file."
  ;; get the class name and its parent
	(let (name parent header)
		(setq name (read-string "Class name: "))
		(setq parent (read-string "Parent class(default=none): " nil nil "__none"))
		;; get the names of the header and source files
		(setq header
					(read-string (concat "Header file name(default=" name ".h): ")
											 nil nil name))
		(find-file (concat
								(file-name-directory buffer-file-name) (concat header ".h")))
		(add-cpp-include-guards header)
		(add-inline-cpp-declaration name parent)
		)
  )

(defun create-inline-cpp-class-here()
  "Create an inline class at the current cursor location."
	(let (name parent)
		;; get the class name and its parent
			(setq name (read-string "Class name: "))
			(setq parent (read-string "Parent class(default=none): " nil nil "__none"))
			(add-inline-cpp-declaration name parent)
			)
		)

(defun create-cpp-class-in-new-file()
  "Create a class in a new header and source file."
	;; get the class name and its parent
	(let (name parent header source)
		(setq name (read-string "Class name: "))
		(setq parent (read-string "Parent class(default=none): " nil nil "__none"))
		;; get the names of the header and source files
		(setq header
					(read-string (concat "Header file name(default=" name ".h): ")
											 nil nil name))
		(setq source
					(read-string (concat "Source file name(default=" name ".cpp): ")
											 nil nil name))
		(find-file (concat
								(file-name-directory buffer-file-name) (concat source ".cpp")))
		(add-cpp-definition name header)
		(find-file (concat
								(file-name-directory buffer-file-name) (concat header ".h")))
		(add-cpp-include-guards header)
		(add-cpp-declaration name parent)
		)
	)

(defun create-cpp-class-here()
  "Create a class at the current cursor location."
	;; get the class name and its parent
  (let (name parent)
		(setq name (read-string "Class name: "))
		(setq parent (read-string "Parent class(default=none): " nil nil "__none"))
		(add-cpp-declaration name parent)
		)
  )

(defun add-cpp-include-guards(file-name)
	"Insert C++ include guards.

FILE-NAME is the name of the header file without the .h."
	(insert "#ifndef " file-name "_h_INCLUDED\n")
	(insert "#define " file-name "_h_INCLUDED\n")
	(insert "\n\n\n#endif")
	;; Move the cursor back between the guards
	(backward-char 8)
	)

(defun add-cpp-declaration(name parent)
  "Insert the class declaration at the current cursor position.

NAME is name of class to be declared.
PARENT is name of superclass of the class."
  (insert "class " name)
  (when (not (string-equal parent "__none"))
		(insert " : public " parent))
  (insert " {\npublic:\n")
  (insert "\t" name "();\n")
  (insert "\t~" name "();\n")
  (insert "\n};")
  )

(defun add-inline-cpp-declaration(name parent)
  "Insert the class declaration at the current cursor position.

NAME is name of class to be declared.
PARENT is name of superclass of the class."
  (insert "class " name)
  (when (not (string-equal parent "__none"))
		(insert " : public " parent))
  (insert " {\npublic:\n")
  (insert "\t" name "() { }\n")
  (insert "\t~" name "() { }")
  (insert "\n};")
  )

(defun add-cpp-definition(name header)
  "Insert the class declaration at the current cursor position.

NAME is the name of the class to be defined.
HEADER is the name of the header where the declaration if the class is."
	(insert "#include \"" header "\"\n\n")
  (insert name "::" name "() {\n\n}\n\n")
  (insert name "::~" name "() {\n\n}")
  )

(defun unsupported(language)
	"Inform the user that this language is not object-oriented.

LANGUAGE is the name of the language the user attempted to add a class to."
	(message (concat language " does not support classes."))
	)

(provide 'cladder)
;;; cladder.el ends here
