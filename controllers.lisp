(in-package :stash)
(enable-annot-syntax)

(defun current-user ()
  (let ((username (lucerne-auth:get-userid)))
    (when username
      (with-database (db "stash")
        (car (find
              (make-instance 'user
                             :login username)
              db))))))

(defmacro render-template-with-user (template &rest parameter-plist)
  `(lucerne:render-template
    (,template)
    :user (current-user)
    ,@parameter-plist))

;;; ==============================
;;; Root, login&logout
;;; ==============================

@lucerne:route app "/"
(lucerne:defview home ()
  (render-template-with-user
   +main-page.html+
   :menu t))

@lucerne:route app "/login"
(lucerne:defview login-page ()
  (lucerne:render-template (+login.html+)))

@lucerne:route app (:post "/login")
(lucerne:defview login ()
  (lucerne:with-params (login password)
    (let ((user (with-database (db "stash")
                  (car (find (make-instance 'user
                                            :login login)
                             db)))))
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

;;; ==============================
;;; Posts
;;; ==============================

@lucerne:route app "/posts"
(lucerne:defview posts ()
  (with-database (db "stash")
    (render-template-with-user
     +posts.html+
     :menu t
     :post-list (find (all-collection 'post) db))))

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

;;; ==============================
;;; Paste functions
;;; ==============================

@lucerne:route app "/paste/add"
(lucerne:defview add-paste-page ()
  (render-template-with-user
   +create-paste.html+
   :menu t))

@lucerne:route app "/paste/:hash-or-id"
(lucerne:defview paste (hash-or-id)
  (with-database (db "stash")
    (let ((paste
           (or
            (car (find (make-instance
                        'paste
                        :hash hash-or-id) db))
            (car (find (make-instance
                        'paste
                        :id hash-or-id) db)))))
      (render-template-with-user
       +paste.html+
       :menu t
       :paste paste))))

(flet ((paste-hash (body timestamp)
         (string->hash (format nil "~a~a" body timestamp)))

       (new-id ()
         (let ((chars "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"))
           (coerce (loop :repeat 5
                      :collect (aref chars
                                     (random (length chars))))
                   'string))))

  @lucerne:route app (:post "/paste/add")
  (lucerne:defview add-paste ()
    (lucerne:with-params (caption language body)
      (with-database (db "stash")
        (let* ((timestamp (get-universal-time))
               (hash (paste-hash body timestamp)))
          (store (make-instance 'paste
                                :caption caption
                                :body (pygmentize body language)
                                :timestamp timestamp
                                :hash hash)
                 db)
          (lucerne:redirect (format nil "/paste/~a" hash))))))

  @lucerne:route app (:post "/sp")
  (lucerne:defview quickpaste ()
    (lucerne:with-params (s)
      ;; s is multipart/form-data, thus it's a flexi-stream instead of regular
      ;; simple string
      (with-database (db "stash")
        (let* ((body (read-flexi-stream-to-string (car s)))
               (id (loop :for id := (new-id)
                      :until (null (find (make-instance 'paste :id id)
                                         db))
                      :finally (return id)))
               (timestamp (get-universal-time))
               (hash (paste-hash body timestamp)))
          (store (make-instance 'paste
                                :body body
                                :timestamp timestamp
                                :hash hash
                                :id id)
                 db)
          (lucerne:respond (format nil "http://specter.link/paste/~a~%" id)
                           :status 200 :type "text/plain"))))))

;;; ==============================
;;; Admin interface
;;; ==============================

@lucerne:route app "/admin"
@restrict-login app nil
(lucerne:defview admin ()
  (render-template-with-user
   +admin.html+
   :menu t))

@lucerne:route app "/admin/settings"
@restrict-login app nil
(lucerne:defview settings ()
  (render-template-with-user
   +settings.html+
   :menu t))

@lucerne:route app (:post "/admin/settings")
@restrict-login app nil
(lucerne:defview settings-action ()
  (lucerne:with-params (delete-posts
                        delete-empty-posts
                        just-redirect)
    (with-database (db "stash")
      (cond
        (delete-posts
         (remove (all-collection "posts") db)
         (make-response 302 '(:location "/posts")))
        (delete-empty-posts
         (remove (make-instance 'post
                                :body ""
                                :caption "")
                 db)
         (make-response 302 '(:location "/posts")))
        (just-redirect
         (make-response 302 '(:location "/")))
        (t (make-response 200))))))

@lucerne:route app "/admin/add-user"
@restrict-login app nil
(lucerne:defview admin-add-user ()
  (render-template-with-user
   +add-user.html+
   :menu t))

@lucerne:route app (:post "/admin/add-user")
@restrict-login app nil
(lucerne:defview add-user ()
  (lucerne:with-params (login
                        password
                        handle
                        adminp
                        email)
    (format t "~A ~A ~A ~A ~A~%" login password handle adminp email)
    (lucerne:redirect "/posts")))

;;; ==============================
;;; Misc
;;; ==============================

@lucerne:route app "/script"
(lucerne:defview script-page ()
  (render-template-with-user
   +script-page.html+
   :menu t
   :script-link-list '("/static/jquery.js")
   :script-code-list
   (list
    (ps
      (defun change-color ()
        (let ((box (chain  document (get-element-by-id "box")))
              (new-color (ps::>> (* (chain |Math| (random))
                                    0xFFFFFF)
                                 0)))
          (setf (@ box style background-color)
                (+ "#" (chain new-color
                         (to-string 16))))))

      (chain ($ document)
        (ready (lambda ()
                 (chain ($ "p.hide")
                   (click (lambda ()
                            (chain ($ this) (hide))))))))))))
