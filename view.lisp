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
          (cl-who:htm
           (cl-who:str
            (cl-who:conc
             ,@body))))
         ,s))))
