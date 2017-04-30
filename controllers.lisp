(in-package :stash)
(enable-annot-syntax)

(defun current-user ()
  (let ((username (lucerne-auth:get-userid)))
    (when username
      (crane:single! 'user :login username))))

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
   :treasure (random 10000)
   :menu t))

@lucerne:route app "/login"
(lucerne:defview login-page ()
  (lucerne:render-template (+login.html+)))

@lucerne:route app (:post "/login")
(lucerne:defview login ()
  (lucerne:with-params (login password)
    (let ((user (crane:single!
                 'user
                 :login login)))
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
  (render-template-with-user
   +posts.html+
   :menu t
   :post-list (crane:filter 'post)))

@lucerne:route app (:post "/posts")
(lucerne:defview add-post ()
  (lucerne:with-params (post-body post-caption)
    (if (not (current-user))
	(make-response 403)
        (progn
          (crane:create 'post
                        :author current-user
                        :caption post-caption
                        :body (stash.model:markdown->html post-body))
          (lucerne:redirect "/posts")))))

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
  (let ((paste
         (or (crane:single! 'paste
                            :hash hash)
             (crane:single! 'paste
                            :short-id id))))
    (render-template-with-user
     +paste.html+
     :menu t
     :paste paste)))

(flet ((paste-hash (body timestamp)
         (string->hash (format nil "~a~a" body timestamp)))
       (new-id ()
         (let ((chars
                "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"))
           (coerce (loop :repeat 5
                      :collect (aref chars
                                     (random (length chars)
                                             (make-random-state t))))
                   'string))))

  @lucerne:route app (:post "/paste/add")
  (lucerne:defview add-paste ()
    (lucerne:with-params (caption language body)
      (let* ((timestamp (get-universal-time))
             (hash (paste-hash body timestamp)))
        (crane:create 'paste
                      :caption caption
                      :body (pygmentize body language)
                      :timestamp timestamp
                      :hash hash)
        (lucerne:redirect (format nil "/paste/~a" hash)))))

  @lucerne:route app (:post "/sp")
  (lucerne:defview quickpaste ()
    (lucerne:with-params (s)
      ;; s is multipart/form-data, thus it's a flexi-stream instead of regular
      ;; simple string
      (let* ((body (read-flexi-stream-to-string (car s)))
             (id (loop :for id := (new-id)
                    :until (not (crane:exists
                                 'paste :id id))
                    :finally (return id)))
             (timestamp (get-universal-time))
             (hash (paste-hash body timestamp)))
        (crane:create 'paste
                      :body body
                      :timestamp timestamp
                      :hash hash
                      :short-id id)
        (lucerne:respond (format nil "http://~a/paste/~a~%"
                                 (config-get :domain) id)
                         :status 200 :type "text/plain")))))

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
    (cond
      (delete-posts
       (crane:delete-from 'post)
       (make-response 302 '(:location "/posts")))
      (just-redirect
       (make-response 302 '(:location "/")))
      (t (make-response 200)))))

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
