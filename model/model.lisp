(in-package :stash.model)

(defmacro with-database ((var database-name) &body body)
  (alexandria:with-gensyms (client)
    `(mongo:with-client (,client (mongo:create-mongo-client
                                  :usocket
                                  :server (make-instance 'mongo:server-config
                                                         :port 27017
                                                         :hostname "127.0.0.1")))
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
  ((|_id| :documentation "Internal mongo '_id' field" :reader mongo-id)
   (collection :initarg :collection :initform (error "Mongo collection must be set")
               :accessor collection)))

(defgeneric store (object database-connection))
(defgeneric remove (object database-connection))
(defgeneric find (object database-connection))

(defmethod store ((object mongo-storable) database-connection)
  (with-collection (c (collection object) database-connection)
    (let ((object-hash (make-slot-value-hash object)))
      (mongo:insert c object-hash))))

(defmethod remove ((object mongo-storable) database-connection)
  (with-collection (c (collection object) database-connection)
    (let ((object-hash (make-slot-value-hash object)))
      (mongo:remove c object-hash))))

(defmethod find ((object mongo-storable) database-connection)
  (with-collection (c (collection object) database-connection)
    (let ((object-hash (make-slot-value-hash object)))
      (mapcar (alexandria:rcurry #'unpack-hash-to-object object)
              (mongo:find c :query object-hash)))))

(defun unpack-hash-to-object (hash object)
  "Function takes hash, which returned from the Mongo, and
unpacks it to corresponding object, or fails loudly"
  (let* ((class (class-of object))
         (hash-alist (alexandria:hash-table-alist hash))
         (new-object (make-instance class)))
    (mapc (lambda (entry)
            (destructuring-bind (slot-name . slot-value) entry
              (setf (slot-value new-object (intern slot-name 'stash.model))
                    slot-value)))
          hash-alist)
    new-object))

(defun get-slot-value-list (object)
  (let* ((class (class-of object))
         (slot-name-list (remove-if
                          (lambda (slot-name)
                            (or (string= slot-name "COLLECTION")
                                (string= slot-name "_id")))
                          (mapcar #'closer-mop:slot-definition-name
                                  (closer-mop:class-slots class))))
         (slot-value-list))
    (dolist (slot-name slot-name-list slot-value-list)
      (and (slot-boundp object slot-name)
           (push (cons slot-name
                       (ensure-valid-value (slot-value object slot-name)))
                 slot-value-list)))))

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

(defun all-collection (collection-name class)
  (make-instance class
                 :collection collection-name))
