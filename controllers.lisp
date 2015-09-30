(in-package :stash)

(defun make-login-controller (app)
  (lambda (params)
    (let ((login (request-param-value params "login"))
          (password (request-param-value params "password"))
          (user *user*))
      (if (and (string= (user-login user) login)
               (user-authorized-p password user))
          (progn
            (setf (gethash :authorized (ningle:context :session)) t)
            (make-response app 302 '(:location "/")))
          (make-response app 302 '(:location "/login"))))))
