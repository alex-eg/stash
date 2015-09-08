(in-package :stash.model)

(defmacro with-database ((var database-name) &body body)
  (alexandria:with-gensyms (client)
    `(mongo:with-client (,client (mongo:create-mongo-client
                                  :usocket))
       (let ((,var (make-instance 'mongo:database :mongo-client ,client
                                  :name ,database-name)))
         (progn ,@body)))))

(defmacro with-collection ((collection collection-name database) &body body)
  `(let ((,collection (mongo:collection ,database ,collection-name)))
     (progn ,@body)))

(defmacro with-database-and-collection ((collection collection-name database database-name) &body body)
  `(with-database (,database ,database-name)
     (let ((,collection (mongo:collection ,database ,collection-name)))
       (progn ,@body))))

;;; Model base class (note: maybe use power of MOP and provide more convenient metaclass?)

(defclass mongo-storable ()
  ((|_id| :documentation "Internal mongo '_id' field")
   (collection :initarg :collection :initform (error "Mongo collection must be set")
               :accessor collection)))

(defgeneric store (object database-connection))

(defmethod store ((object mongo-storable) database-connection)
  (let ((collection (mongo:collection database-connection
                                      (collection object)))
        (object-hash (make-slot-value-hash object)))
    (mongo:insert collection object-hash)))

(defun get-slot-value-list (object)
  (let* ((class (class-of object))
         (slot-name-list (remove-if (lambda (slot-name)
                                      (or (string= slot-name "COLLECTION")
                                          (string= slot-name "_id")))
                                    (mapcar #'closer-mop:slot-definition-name
                                               (closer-mop:class-slots class)))))
    (mapcar (lambda (slot-name) (cons slot-name
                                      (or (and (slot-boundp object slot-name)
                                               (ensure-valid-value (slot-value object slot-name)))
                                          "")))
            slot-name-list)))

(defun ensure-valid-value (object)
  (etypecase object
    (string object)
    (single-float object)
    (double-float object)
    (fixnum object)
    (list (make-hash-array object))
    (simple-vector (make-hash-array object))
    (t (make-slot-value-hash object))))

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

(defun make-hash-array (sequence)
  (map 'simple-vector
       #'ensure-valid-value
       sequence))

(defun hash-to-object (hash class-name-symbol)
  (let* ((class (intern (symbol-name class-name-symbol) *package*))
         (object (make-instance class)))
    'pass))