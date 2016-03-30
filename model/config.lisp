(in-package :stash.model)

(defvar *config* nil
  "Global config storage object")

(defun config-get (key &optional conf-list)
  (if (conf-list)
      (cadr (assoc key conf-list))
      (gethash key *config*)))

(defun (setf config-get) (new-value key)
  (setf (gethash key *config*) new-value))

(defun read-config-file (filename)
  (with-open-file (file filename :direction :input)
    (loop :for entry := (read file nil :eof)
       :until (eq entry :eof)
       :collect entry)))

(defun init-config (config-file-path)
  (setq *config*
        (config-list->hash (read-config-file config-file-path))))
