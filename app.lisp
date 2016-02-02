(in-package :stash)

(defvar *user*
  (make-instance 'user
                 :login "login"
                 :handle "Haru6aTop"
                 :adminp nil
                 :password (string->hash "TpyCuKu")))

(setf (slot-value *user* 'stash.model::|_id|) 0)

(defmacro install-routes% (app &body routes)
  `(progn
     ,@(loop :for r :in routes
          :collect `(setf (ningle:route ,app ,(car r) ,@(cddr r))
                          ,(cadr r)))))

(defun install-routes (app)
  (install-routes% app
    ;; <route> <function> [ningle:route arguments]*
    ("/" #'main-page)

    ("/login" #'login-page)
    ("/login" (make-login-controller app) :method :post)

    ("/logout" (make-logout-controller app))

    ("/newentry" (logged-in-only #'newentry))
    ("/newentry" (logged-in-only (make-new-post-controller app)) :method :post)

    ("/hello/:name" #'hello-page)

    ("/posts" #'posts-list-page)
    ("/posts" (make-new-post-controller app) :method :post)

    ("/update-settings" #'admin-page)
    ("/update-settings" (make-admin-controller app) :method :post)

    ("/paste/create" #'create-paste-page)
    ("/paste/create" (make-paste-controller app) :method :post)

    ("/paste/*" #'show-paste-page)
    ("/script" #'simple-script)))

(defun generate-css ()
  (generate-general-css)
  (generate-pygments-css "tango"))

(defun print-hash (hash)
  (loop
     for k being the hash-key of hash
       using (hash-value v) do (format t "~A ~A~%" k v)))

;;; HARDCODE DEVELOPMENT
(defvar *source-location* (current-file-location))
(defvar *server* nil)

(defun start ()
  (setf *default-pathname-defaults* *source-location*)
  (generate-css)
  (setf (cl-who:html-mode) :html5)
  (let ((app (make-instance 'ningle:<app>))
        (config (load-config-from-file #P"default-config.lisp")))
    (install-routes app)
    (clack:clackup
     (lack:builder
      :session
      (:static
       :path "/static/"
       :root (merge-pathnames (static-path config)
                              (or *source-location* ; development setting
                                  (root-path config))))
      app))))

(defun start-server (&key (reload-stash nil))
  (when *server*
    (stop-server))
  (when reload-stash
    (ql:quickload :stash))
  (setf *server* (start)))

(defun stop-server ()
  (clack:stop *server*)
  (setf *server* nil))
