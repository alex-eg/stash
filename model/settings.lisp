(in-package :stash.model)

(defclass settings (mongo-storable)
  ((static-path :initarg :static-path :accessor static-path)))

(defun load-settings-from-file (filename)
  (with-open-file (file filename :direction :input)
    (loop :for entry := (read file nil :eof)
       :until (eq entry :eof)
       :collect entry)))
