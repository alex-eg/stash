(in-package :stash)

(defun make-login-controller (app)
  (lambda (params)
    (let ((login (request-param-value params "login"))
          (password (request-param-value params "password"))
          (user *user*)) ; temporary. later will be queried from DB
      (if (and (string= (user-login user) login)
               (user-authorized-p password user))
          (progn
            (setf (gethash :authorized (ningle:context :session)) t)
            (setf (ningle:context :current-user) user)
            (make-response app 302 '(:location "/")))
          (make-response app 302 '(:location "/login"))))))

(defun make-logout-controller (app)
  (lambda (params)
    (let ((s (ningle:context :session)))
      (remhash :authorized s))
    (make-response app 302 '(:location "/"))))

(defmacro logged-in-only (app view-renderer &key redirect-function)
  (let ((redirect-function (or redirect-function
                               (lambda ()
                                 (make-response app 404)))))
    `(lambda (params)
       (if (not (gethash :authorized (ningle:context :session) nil))
           (funcall ,redirect-function)
           (funcall ,view-renderer params)))))

(defun make-new-post-controller (app)
  (lambda (params)
    (let ((body (request-param-value params "post-body"))
          (caption (request-param-value params "post-caption"))
          (user-id (mongo-id (ningle:context :current-user))))
      (store (make-instance 'post
                            :author-id user-id
                            :caption caption
                            :body body)))))
