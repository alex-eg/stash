(in-package :stash.views)

(defmacro define-view (name parameters &body body)
  (labels ((collect-tags (body tag)
             (loop :for entry :in body
                   :if (eql (car entry) tag)
                     :collect entry))
           (remove-tags (body tag)
             (remove tag body :test #'eql :key #'car)))
    (check-type name symbol "symbol")
    (check-type parameters list "lambda list")
    (let* ((scripts (loop :for script :in (collect-tags body :script)
                          :collect `(:script (str ,(cadr script)))))
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
                     (:link :rel "stylesheet" :type "text/css" :href "/static/main.css")
                     ,@css-list
                     ,@scripts)
                    (:body
                     ,@body))
             ,s))))))
