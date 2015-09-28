(in-package :stash.views)

;;; route "/"
(define-view main-page (params)
  (str (header params))
  (:div :id "main-area"
        (:p (str
             (let ((h (or params ningle:*context*)))
               (if h
                   (loop for k being the hash-key of h using (hash-value v)
                      do (htm
                          (:p
                           (str (fmt "~A ~A" k v)))
                          (:br)))
                   (fmt "Hello there~~"))))))
  (:p (str (fmt "DPD: ~s" *default-pathname-defaults*)))
  (:br)
  (:p (str (fmt "RESPONSE: ~s" ningle:*response*))))

;;; route "/login"
(define-view login-page (params)
  (:div :class "login" :align "center"
        (:form :class "login"
               :action "./login"
               :method "post"
               (:label (str "Login")) (:input :type "text" :name "login") (:br)
               (:label (str "Password")) (:input :type "password" :name "password")
               (:input :type "submit" :value "Log in"))))
