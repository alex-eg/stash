(in-package :stash.model)

(defclass paste (mongo-storable)
  ((collection :initform "pastes")
   (hash :initarg :hash :initform (error "Cannot store paste without hash"))
   (timestamp :initarg :timestamp)
   (caption :initarg :caption)
   (body :initarg :body)))

(defun pygmentize (code language)
  (with-input-from-string (s code)
    (uiop/run-program:run-program
     (format nil "pygmentize -f html -l ~a" language)
     :output '(:string :stripped t)
     :input s)))
