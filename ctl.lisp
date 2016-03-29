(in-package :stash)

(defun start-server ()
  (let ((swank:*use-dedicated-output-stream* nil))
    (swank:create-server :coding-system "utf-8-unix"
                         :dont-close t
                         :port 4008)))
