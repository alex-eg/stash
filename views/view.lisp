(in-package :stash.views)

(defun collect-tags (body tag)
  (loop :for entry :in body
     :if (eql (car entry) tag)
     :collect entry))

(defun remove-tags (body tag)
  (remove tag body :test #'eql :key #'car))

(defmacro define-view (name parameters &body body)
  (check-type name symbol "symbol")
  (check-type parameters list "lambda list")
  (let* ((scripts (collect-tags body :script))
         (body (remove-tags body :script))
         (css-list (loop
                      :for css :in (collect-tags body :css)
                      :collect `(:link :rel "stylesheet" :type "text/css" :href ,(cadr css))))
         (body (remove-tags body :css)))
    (alexandria:with-gensyms (s)
      `(defun ,name ,parameters
         (with-html-output-to-string (,s nil :prologue t :indent t)
           (:html (:head
                   (:meta :charset "UTF-8")
                   (:link :rel "stylesheet" :type "text/css" :href "./static/main.css")
                   ,@css-list
                   ,@scripts)
                  (:body
                   ,@body))
           ,s)))))

(define-view hello-page (params)
  (str (header params))
  (:div :id "hello-area"
        (:p (:b (fmt "Hello, ~A" (cdr (assoc :name params)))))))
