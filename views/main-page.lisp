(in-package :stash.views)

;;; route "/"
(define-view main-page (params)
  (str(header params)))

;;; route "/login"
(define-view login-page (params)
  (:div :class "login" :align "center"
        (:form :class "login"
               :action "./login"
               :method "post"
               (:label (str "Login")) (:input :type "text" :name "login") (:br)
               (:label (str "Password")) (:input :type "password" :name "password") (:br)
               (:input :type "submit" :value "Log in"))))
