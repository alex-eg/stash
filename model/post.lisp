(in-package :stash.model)

(defun post ()
  'pass)

(defun markdown->html (text)
  (cl-markdown:markdown text))
