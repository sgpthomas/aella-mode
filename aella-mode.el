;;; aella-mode.el -*- lexical-binding: t; -*-

;; Copyright (C) 2022 Samuel Thomas

;;; Code:

(require 'tree-sitter)
(require 'tree-sitter-indent)

(defcustom aella-indent-offset 4
  "Indent offset for Aella")

(defvar tree-sitter-indent-aella-scopes
  '((indent-all
     ;; these nodes are always indented
     . ())
    (indent-rest
     ;; if parent node is one of these and node is not first → indent
     . (while))
    (indent-body
     ;; if parent node is one of these and current node is in middle → indent
     . (while))
    (paren-indent
     ;; if parent node is one of these → indent to paren opener
     . ())
    (align-char-to
     ;; chaining char → node types we move parentwise to find the first chaining char
     . ())
    (aligned-siblings
     ;; siblings (nodes with same parent) should be aligned to the first child
     . ())
    (multi-line-text
     ;; if node is one of these, then don't modify the indent
     ;; this is basically a peaceful way out by saying "this looks like something
     ;; that cannot be indented using AST, so best I leave it as-is"
     . ())
    (outdent
     ;; these nodes always outdent (1 shift in opposite direction)
     . ())
    (align-to-node-line
     ;; this group has lists of alist (node type . (node types... ))
     ;; we move parentwise, searching for one of the node
     ;; types associated with the key node type. if found,
     ;; align key node with line where the ancestor node
     ;; was found.
     . ()))
  "Scopes for indenting in Aella.")

(defconst aella-mode-tree-sitter-patterns
  [ ;; Various constructs
   ["while"] @keyword
   (var) @variable
   (int) @number
   ])

(define-derived-mode aella-mode prog-mode "Aella Mode"
  "A major mode for editing Aella source files."

  (tree-sitter-load 'aella "/Users/sgt/Research/tree-sitter-aella/aella")

  (add-to-list 'tree-sitter-major-mode-language-alist '(aella-mode . aella))

  ;; tree sitter queries
  (setq-local tree-sitter-hl-default-patterns
	      aella-mode-tree-sitter-patterns)

  (tree-sitter-hl-mode)
  (tree-sitter-indent-mode))

(provide 'aella-mode)

;;; aella-mode.el ends here
