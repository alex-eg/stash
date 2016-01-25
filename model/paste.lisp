(in-package :stash.model)

(defclass paste (mongo-storable)
  ((collection :initform "pastes")
   (hash :initarg :hash :initform (error "Cannot store paste without hash"))
   (timestamp :initarg :timestamp)
   (caption :initarg :caption)
   (body :initarg :body)))
