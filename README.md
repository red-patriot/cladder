# cladder
Emacs class adder: a package to auto-generate class definitions.

This package adds the interactive command `add-class` to emacs, which auto-generates a declaration and/or definition for a class. By default, this fucntion is bound to C-x C-a, but this can be modified by editing the source code. 

# Supported Languages
- C++
- Python

# Installing
 First, clone this repository.
 To add cladder to your emacs, make sure to add both cladder.el and cladder.elc to a file on the emacs load path, or add its location to the load path with 
 
 `(add-to-list 'load-path "~/path/to/file/location/")`

Then on the next line, add

`(require 'cladder)` 

to load and use cladder.

# Contributing
Please feel free to update this package with support for more languages or submit suggestions or requests. 
Testers are greatly appreciated! Please download and add this package to your own emacs config to test it!
