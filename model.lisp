(in-package :stash.model)

(defclass mongo-storable () ())

(defgeneric store (object))
(defgeneric pull (object))

(defmethod store ((object mongo-storable))
  'pass)
(defmethod pull ((object mongo-storable))
  'pass)
