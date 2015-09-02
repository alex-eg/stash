(in-package :stash.views)

(defun header (params)
  (declare (ignore params))
  (cl-who:with-html-output-to-string (s nil :indent t)
    (cl-who:htm
     (:div :id "header"
           (:div :id "row"
                 (:div :id "left"
                       (:a :href "/login" (cl-who:str "Login"))))))))
