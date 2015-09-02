(in-package :stash.views)

;;; route "/"
(define-view main-page (params)
  (header params)
  (cl-who:htm
   (:div :id "main-area"
         (:p (cl-who:str
              (if params
                  (loop for k being the hash-key of params using (hash-value v) do (cl-who:fmt "~A ~A~%" k v))
                  (cl-who:fmt "Hello there~~")))))))

(define-view login-page (params)
  (header params))
