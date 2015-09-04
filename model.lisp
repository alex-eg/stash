(in-package :stash.model)

(defclass mongo-storable ()
  ((collection :initarg :collection :initform (error "Mongo collection must be set")
               :accessor collection)))

(defgeneric store (object database-connection))

(defmethod store ((object mongo-storable) database-connection)
  (let ((collection (mongo:collection database-connection
                                      (collection object)))
        (object-hash (make-slot-value-hash object)))
    (mongo:insert collection object-hash)))

(defun get-slot-value-list (object)
  (let* ((class (class-of object))
         (slot-name-list (mapcar #'closer-mop:slot-definition-name
                            (closer-mop:class-slots class))))
    (mapcar (lambda (slot-name) (cons slot-name  (or (and (slot-boundp object slot-name)
                                                          (slot-value object slot-name))
                                                     "")))
            slot-name-list)))

(defun make-slot-value-hash (object)
  (let* ((slot-value-list (get-slot-value-list object))
         (hash (make-hash-table :size (length slot-value-list))))
    (mapcar (lambda (slot-value)
              (destructuring-bind (slot . value) slot-value
                (setf (gethash (symbol-name slot)
                               hash)
                      value)))
            slot-value-list)
    hash))
