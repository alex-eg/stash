(in-package :stash.model)

(defclass post (mongo-storable)
  ((collection :initform "posts")
   (author-id :initarg :author-id :reader post-author-id)
   (caption :initarg :caption :reader post-caption)
   (visibility :initarg :visibility :reader post-visibility)
   (body :initarg :body :reader post-body)))

(defun markdown->html (text)
  (with-output-to-string (s)
    (cl-markdown:markdown
     (escape-string text)
     :stream s)))
