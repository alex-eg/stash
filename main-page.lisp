(in-package :stash.views)

;;; route "/"
(define-view main-page (params)
  (cl-who:str (header params))
  (:div :id "main-area"
        (:p (cl-who:str
             (if params
                 (loop for k being the hash-key of params using (hash-value v) do (cl-who:fmt "~A ~A~%" k v))
                 (cl-who:fmt "Hello there~~"))))))

(define-view login-page (params)
  (:form :id "login"
         :action "./login"
         :method "post"
         (cl-who:str "Login") (:input :type "text" :name "login") (:br)
         (cl-who:str "Password") (:input :type "password" :name "password") (:br)
         (:input :type "submit" :value "Log in")))
