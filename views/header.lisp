(in-package :stash.views)

(defun header (params)
  (declare (ignore params))
  (with-html-output-to-string (s nil :indent t)
    (htm
     (:ul :class "header"
          (:li (:a :href "/" (str "Home")))
          (:li (:a :href "/script" (str "Some JS")))
          (:li (:a :href "/paste/create" (str "Code paste")))
          (if (gethash :authorized (ningle:context :session))
              (htm
               (:li (:a :href "/posts" (str "All posts")))
               (:li (:a :href "/newentry" (str "New entry")))
               (:li (:a :href "/update-settings" (str "Settings")))
               (:li (:a :href "/logout" (str "Log out"))))
              (htm
               (:li (:a :href "/login" (str "Log In")))))))))
