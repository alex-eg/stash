(in-package :stash.views)

(define-view main-page (params)
  (esc (format nil "~{~S~%~}~%"
            (loop :for key :being :the :hash-keys :of ningle:*context*
                    :using (:hash-value value)
                  :collect (list key value))))
  (esc (format-value ningle:*context*))
  (esc (gethash :session ningle:*context*))
  (esc (ningle:context :session))
  (str (header params)))
