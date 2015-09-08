(in-package :stash)

(defvar *user*
  (make-instance 'stash.model::user
                 :collection "users"
                 :login "login"
                 :handle "Haru6aTop"
                 :password (stash.model::string->hash "TpyCuKu")))

(defun install-routes (app)
  (setf (ningle:route app "/")
        #'stash.views::main-page)
  (setf (ningle:route app "/login")
        #'stash.views::login-page)
  (setf (ningle:route app "/login" :method :post)
        #'(lambda (params)
            (let ((login (cdr (assoc "login" params :test #'string=)))
                  (password (cdr (assoc "password" params :test #'string=)))
                  (user *user*))
              (if (and (string= (stash.model::user-login user) login)
                       (string= (stash.model::string->hash password)
                                (stash.model::user-password user)))
                  (progn
                    (let ((s (gethash :session ningle:*context*)))
                      (setf (gethash :authorized s) t))
                    "You're authorized! Hooray!")
                  "I don't know you. Go away."))))
  (setf (ningle:route app "/logout")
        #'logout)
  (setf (ningle:route app "/hello/:name")

        #'stash.views::hello-page))

(defun generate-css ()
  (stash.views::generate-general-css))

(defun logout (params)
  ())

(defun print-hash (hash)
  (loop
     for k being the hash-key of hash
       using (hash-value v) do (format t "~A ~A~%" k v)))

(defun start ()
  (generate-css)
  (setf (cl-who:html-mode) :html5)
  (let ((app (make-instance 'ningle:<app>)))
    (install-routes app)
    (clack:clackup
     (lack:builder :session
                   app))))
