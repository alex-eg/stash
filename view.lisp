(in-package :stash.views)

(defmacro define-view (name parameters &body body)
  (check-type name symbol "symbol")
  (check-type parameters list "lambda list")
  (alexandria:with-gensyms (s)
    `(defun ,name ,parameters
       (cl-who:with-html-output-to-string (,s nil :prologue t :indent t)
         (:head
          (:meta :charset "UTF-8"))
         (:body
          ,@body)
         ,s))))

(define-view hello-page (params)
  (cl-who:str (header params))
  (:div :id "hello-area"
        (:p (:b (cl-who:fmt "Hello, ~A" (cdr (assoc :name params)))))))
