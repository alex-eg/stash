(in-package :stash.model)

(defun markdown->html (text)
  (cl-markdown:markdown text))
