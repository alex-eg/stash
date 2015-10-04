(in-package :stash.views)

(defun header (params)
  (declare (ignore params))
  (with-html-output-to-string (s nil :indent t)
    (:div :id "header"
          (:div :id "row"
                (:div :id "left"
                      (if (gethash :authorized (ningle:context :session))
                          (htm (:a :href "/logout" (str "Log out")))
                          (htm (:a :href "/login" (str "Log In")))))))))
