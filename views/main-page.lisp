(in-package :stash.views)

(define-view main-page (params)
  (esc (format nil "~{~S~%~}~%"
               (loop :for key :being :the :hash-keys :of ningle:*context*
                  :using (:hash-value value)
                  :collect (list key value))))
  (str (header params)))
