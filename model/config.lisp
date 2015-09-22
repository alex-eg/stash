(in-package :stash.model)

(defclass config (mongo-storable)
  ((static-path :accessor static-path)
   (root-path :accessor root-path)))

(defun read-file (filename)
  (let ((*package* (find-package :stash.model)))
    (with-open-file (file filename :direction :input)
      (loop :for entry := (read file nil :eof)
         :until (eq entry :eof)
         :collect entry))))

(defun load-config-from-file (filename)
  (let* ((config-list (read-file filename))
         (config (make-instance 'config :collection "config"))
         (class (class-of config))
         (slots (mapcar #'closer-mop:slot-definition-name
                        (closer-mop:class-slots class))))
    (loop
       :for entry :in config-list
       :do (destructuring-bind (key value) entry
             (if (member key slots)
                 (setf (slot-value config key) value)
                 (format t "Unknown config line: ~s~%" (list key value)))))
    config))
