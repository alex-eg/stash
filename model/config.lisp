(in-package :stash.model)

(defclass config (mongo-storable)
  ((collection :initform "config")
   (static-path :accessor static-path)
   (root-path :accessor root-path)
   (domain :accessor config-domain-name))
  (:metaclass mongo-storable-meta))

(defun read-config-file (filename)
  (let ((*package* (find-package :stash.model)))
    (with-open-file (file filename :direction :input)
      (loop :for entry := (read file nil :eof)
         :until (eq entry :eof)
         :collect entry))))

(defmacro do-config-list ((config-list key value) &body body)
  (alexandria:with-gensyms (entry)
    `(loop
        :for ,entry :in ,config-list
        :do (destructuring-bind (,key ,value) ,entry
              (progn ,@body)))))

(defun config-development-p (config-list)
  (if (member 'development config-list :key #'car)
      (cadr (cl:find 'development config-list))
      t))                               ; if development section is
                                        ; missing, assuming t by
                                        ; default

(defun create-config-from-config-list (config-list)
  (let* ((config (make-instance 'config))
         (class (class-of config))
         (slots (mapcar #'closer-mop:slot-definition-name
                        (closer-mop:class-slots class))))
    (do-config-list (config-list key value)
      (if (member key slots)
          (setf (slot-value config key) value)
          (format t "Unknown config key: ~s~%" (list key value))))
    config))

(defun load-config-from-file (filename)
  (let ((config-list (read-config-file filename)))
    (create-config-from-config-list config-list)))
