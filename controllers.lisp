(in-package :stash)

(defun make-login-controller (app)
  (lambda (params)
    (let ((login (request-param-value params "login"))
          (password (request-param-value params "password"))
          (user *user*) ; temporary. later will be queried from DB
          (session (ningle:context :session)))
      (if (and (string= (user-login user) login)
               (user-authorized-p password user))
          (progn
            (setf (gethash :authorized session) t)
            (setf (gethash :current-user session) user)
            (make-response 302 '(:location "/")))
          (make-response 302 '(:location "/login"))))))

(defun make-logout-controller (app)
  (lambda (params)
    (let ((s (ningle:context :session)))
      (remhash :authorized s))
    (make-response 302 '(:location "/"))))

(defmacro logged-in-only (view-renderer &key redirect-function)
  (let ((redirect-function (or redirect-function
                               (lambda ()
                                 (make-response 404)))))
    (alexandria:with-gensyms (params)
      `(lambda (,params)
         (if (not (gethash :authorized (ningle:context :session) nil))
             (funcall ,redirect-function)
             (funcall ,view-renderer ,params))))))

(defun make-new-post-controller (app)
  (lambda (params)
    (let ((body (request-param-value params "post-body"))
          (caption (request-param-value params "post-caption"))
          (user-id (aif (gethash :current-user (ningle:context :session))
                        (mongo-id it)
                        "0")))
      (with-database (db "stash")
        (store (make-instance 'post
                              :author-id user-id
                              :caption caption
                              :body (stash.model:markdown->html body))
               db)))
    (make-response 302 '(:location "/posts"))))

(defun make-admin-controller (app)
  (lambda (params)
    (with-database (db "stash")
      (cond
        ((request-param-value params "delete-posts")
         (remove (all-collection "posts") db)
         (make-response 302 '(:location "/posts")))
        ((request-param-value params "delete-emply-posts")
         (remove (make-instance 'post
                                :body ""
                                :caption "")
                 db)
         (make-response 302 '(:location "/posts")))
        ((request-param-value params "just-redirect")
         (make-response 302 '(:location "/")))
        (t (make-response 200))))))

(defun make-paste-controller (app)
  (lambda (params)
    (with-database (db "stash")
      (let* ((caption (request-param-value params "paste-caption"))
             (body (request-param-value params "paste-body"))
             (language (request-param-value params "language"))
             (timestamp (get-universal-time))
             (hash (string->hash (format nil "~a~a" body timestamp))))
        (store (make-instance 'paste
                              :caption caption
                              :body (pygmentize body language)
                              :timestamp timestamp
                              :hash hash)
               db)
        (make-response 302 (list :location (format nil "/paste/~a" hash)))))))
