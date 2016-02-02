(in-package :stash.views)

(defun header (params)
  (declare (ignore params))
  (with-html-output-to-string (s nil :indent t)
    (htm
     (:ul :class "header"
          (:li (:a :href "/" (str "Home")))
          (:li (:a :href "/script" (str "Some JS")))
          (:li (:a :href "/paste/create" (str "Code paste")))
          (if current-user%
              (progn
                (htm
                 (:li (:a :href "/posts" (str "All posts")))
                 (:li (:a :href "/newentry" (str "New entry"))))
                (if (user-adminp current-user%)
                    (htm
                     (:li (:a :href "/admin" (str "Administration")))))
                (htm (:li (:a :href "/logout" (str "Log out")))))
              (htm
               (:li (:a :href "/login" (str "Log In")))))))))
