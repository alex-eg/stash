(in-package :stash.views)

(defmacro define-view (name parameters &body body)
  (check-type name symbol "symbol")
  (check-type parameters list "lambda list")
  (let ((scripts (loop
                    :for entry :in body
                    :if (eql (car entry) :script)
                    :collect entry)))
    (alexandria:with-gensyms (s)
      `(defun ,name ,parameters
         (with-html-output-to-string (,s nil :prologue t :indent t)
           (:head
            (:meta :charset "UTF-8")
            (:link :rel "stylesheet" :type "text/css" :href "./static/main.css")
            ,@scripts)
           (:body
            ,@body)
           ,s)))))

(define-view hello-page (params)
  (str (header params))
  (:div :id "hello-area"
        (:p (:b (fmt "Hello, ~A" (cdr (assoc :name params)))))))
