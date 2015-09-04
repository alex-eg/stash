(in-package :stash.model)

(defclass mongo-storable ()
  ((collection :initarg :collection :initform (error "Mongo collection must be set")
               :accessor collection)))

(defgeneric store (object))
(defgeneric pull (object))

(defmethod store ((object mongo-storable))
  'pass)
(defmethod pull ((object mongo-storable))
  'pass)
