(in-package :stash.model)

(defclass post (mongo-storable)
  ((collection :initform "posts")
   (author-id :initarg :author-id)
   (caption :initarg :caption)
   (visibility :initarg :visibility)
   (body :initarg :body)))

(defun markdown->html (text)
  (cl-markdown:markdown
   (cl-who:escape-string text)))
