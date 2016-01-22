(in-package :stash.model)

(defclass post (mongo-storable)
  ((collection :initform "posts")
   (author-id :initarg :author-id)
   (caption :initarg :caption)
   (visibility :initarg :visibility)
   (body :initarg :body)))

(defun escape-string (string)
  (with-output-to-string (s)
    (map nil
         (lambda (char)
           (case char
             ((#\<)
              (write-sequence "&lt;" s))
             ((#\>)
              (write-sequence "&gt;" s))
             ((#\&)
              (write-sequence "&amp;" s))
             ((#\')
              (write-sequence "&#039;" s))
             ((#\")
              (write-sequence "&quot;" s))
             ((#\)
              nil)
             (otherwise
              (format s "~c" char))))
         string)))

(defun markdown->html (text)
  (with-output-to-string (s)
    (cl-markdown:markdown
     (escape-string text)
     :stream s)))
