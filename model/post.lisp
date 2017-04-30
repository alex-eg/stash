(in-package :stash.model)

(deftable post ()
  (caption :type text :nullp nil)
  (visibility :type int)
  (body :type text :nullp nil)
  (author :type int :foreign user :nullp nil))

(defun markdown->html (text)
  (with-output-to-string (s)
    (cl-markdown:markdown
     (escape-string text)
     :stream s)))
