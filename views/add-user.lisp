(in-package :stash.views)

(define-view add-user-page (params)
  (str (header params))
  (:script
   (defun get (id)
     (chain document (get-element-by-id id)))
   (defun check-fields ()
     (let ((login (get "login"))
           (pw (get "password"))
           (pw-confirm (get "password-confirm"))
           (handle (get "handle"))
           (email (get "email"))
           (error-box (get "error-message-text")))
       (cond
         ((!= (@ pw value) (@ pw-confirm value))
          (setf (@ error-box |innerHTML|) "Password didn't match"))
         (t (setf (@ error-box |innerHTML|) "")))))
   (defun try-create-user ()
     (check-fields)))
  (:form :action "/admin/adduser"
         :method "post"
         (:label (str "Login")) (:input :type "text" :name "user-login") (:br)
         (:label (str "Password")) (:input :type "password" :name "user-password" :id "password") (:br)
         (:label (str "Confirm password")) (:input :type "password" :id "password-confirm") (:br)
         (:label (str "Display name")) (:input :type "text" :name "user-handle") (:br)
         (:label (str "Admin?")) (:input :type "checkbox" :name "user-adminp") (:br)
         (:label (str "Email")) (:input :type "text" :name "email") (:br)
         (:input :type "submit" :name "create-user" :value "Create user") (:br)))
