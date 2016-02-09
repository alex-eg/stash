(in-package :stash)
(enable-annot-syntax)

(defun current-user ()
  (let ((username (lucerne-auth:get-userid)))
    (when username
      (with-database (db "stash")
        (find (make-instance 'user
                             :login username)
              db)))))

@lucerne:route app "/"
(lucerne:defview home ()
  (lucerne:render-template (+main-page.html+) :menu t))

@lucerne:route app "/login"
(lucerne:defview login-page ()
  (lucerne:render-template (+login.html+)))

@lucerne:route app (:post "/login")
(lucerne:defview login ()
  (lucerne:with-params (login password)
    (let ((user *user*))      ; temporary. later will be queried from DB
      (if (and (string= (user-login user) login)
               (user-authorizedp password user))
          (progn
            (lucerne-auth:login login)
            (lucerne:redirect "/"))
          (progn (lucerne:redirect "/login"))))))

@lucerne:route app "/logout"
(lucerne:defview logout ()
  (when (lucerne-auth:logged-in-p)
    (lucerne-auth:logout))
  (lucerne:redirect "/"))

@lucerne:route app "/script"
(lucerne:defview script-page ()
  (lucerne:render-template
   (+script-page.html+)
   :menu t
   :script-list
   (list
    (ps
      (defun change-color ()
        (let ((box (chain  document (get-element-by-id "box")))
              (new-color (ps::>> (* (chain |Math| (random))
                                    0xFFFFFF)
                                 0)))
          (setf (@ box style background-color)
                (+ "#" (chain new-color
                         (to-string 16))))))))))

@lucerne:route app "/posts"
(lucerne:defview posts ()
  (with-database (db "stash")
    (lucerne:render-template
     (+posts.html+)
     :menu t
     :post-list (find (all-collection "posts" 'post) db))))

@lucerne:route app (:post "/posts")
(lucerne:defview add-post ()
  (lucerne:with-params (post-body post-caption)
    (let ((user-id (aif (current-user)
                        (mongo-id it)
                        "0")))
      (with-database (db "stash")
        (store (make-instance 'post
                              :author-id user-id
                              :caption post-caption
                              :body (stash.model:markdown->html post-body))
               db))))
  (lucerne:redirect "/posts"))

@lucerne:route app "/paste/add"
(lucerne:defview add-paste-page ()
  (lucerne:render-template (+create-paste.html+)
                           :menu t))

@lucerne:route app (:post "/paste/add")
(lucerne:defview add-paste ()
  (lucerne:with-params (caption language body)
    (with-database (db "stash")
      (let* ((timestamp (get-universal-time))
             (hash (string->hash (format nil "~a~a" body timestamp))))
        (store (make-instance 'paste
                              :caption caption
                              :body (pygmentize body language)
                              :timestamp timestamp
                              :hash hash)
               db)
        (lucerne:redirect (format nil "/paste/~a" hash))))))

@lucerne:route app "/paste/:paste-hash"
(lucerne:defview paste (paste-hash)
  (with-database (db "stash")
    (lucerne:render-template
     (+paste.html+)
     :menu t
     :paste (car
             (find (make-instance
                    'paste
                    :hash paste-hash) db)))))

@lucerne:route app "/admin"
(lucerne:defview admin ()
  (lucerne:render-template
   (+admin.html+)
   :menu t))

@lucerne:route app "/admin/settings"
(lucerne:defview settings ()
  (lucerne:render-template
   (+settings.html+)
   :menu t))

@lucerne:route app (:post "/admin/settings")
(lucerne:defview settings-action ()
  (lucerne:with-params (delete-posts
                        delete-empty-posts
                        just-redirect)
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

@lucerne:route app "/admin/add-user"
(lucerne:defview admin ()
  (lucerne:render-template
   (+add-user.html+)
   :menu t))

@lucerne:route app (:post "/admin/add-user")
(lucerne:defview add-user ()
  (lucerne:with-params (login
                        password
                        handle
                        adminp
                        email)
    (format t "~A ~A ~A ~A ~A~%" login password handle adminp email)
    (lucerne:redirect "/posts")))
