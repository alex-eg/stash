(in-package :stash.views)

(defun header (params)
  (declare (ignore params))
  (with-html-output-to-string (s nil :indent t)
    (if (gethash :authorized (ningle:context :session))
        (progn
          (htm (:a :href "/logout" (str "Log out"))
               (:a :href "/newentry" (str "New entry"))))
        (progn (htm (:a :href "/login" (str "Log In")))))))
