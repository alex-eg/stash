(in-package :stash)

(defvar *user*
  (make-instance 'user
                 :login "login"
                 :handle "Haru6aTop"
                 :adminp nil
                 :password (string->hash "TpyCuKu")))

(setf (slot-value *user* 'stash.model::|_id|) 0)

(djula:add-template-directory (relative-path #P"views/"))

(defmacro compile-templates (template-list)
  (let ((defparameter-list
         (mapcar (lambda (sym)
                   `(defparameter
                        ,(intern (format nil "+~A+" sym) :stash)
                      (djula:compile-template*
                       ,(string-downcase (symbol-name sym)))))
                 template-list)))
    `(progn ,@defparameter-list)))

(compile-templates (head.html
                    base.html
                    main-page.html
                    script-page.html
                    posts.html
                    login.html

                    paste.html
                    create-paste.html

                    admin.html
                    add-user.html
                    settings.html))

(lucerne:defapp app
    :middlewares
  (clack.middleware.session:<clack-middleware-session>
   (clack.middleware.static:<clack-middleware-static>
    :path "/static/"
    :root (relative-path #P"static/"))))

(defun start-server (&key (reload-stash nil))
  (lucerne:stop app)
  (when reload-stash
    (ql:quickload :stash))
  (lucerne:start app))

(defun stop-server ()
  (lucerne:stop app))
