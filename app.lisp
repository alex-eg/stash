(in-package :stash)

(defvar *user*
  (make-instance 'user
                 :login "login"
                 :handle "Haru6aTop"
                 :adminp nil
                 :password (string->hash "TpyCuKu")))

(setf (slot-value *user* 'stash.model::|_id|) 0)

(defmacro compile-templates (template-list)
  (let ((defparameter-list
         (mapcar (lambda (sym)
                   `(defparameter
                        ,(intern (format nil "+~A+" sym) :stash)
                      (djula:compile-template*
                       ,(string-downcase (symbol-name sym)))))
                 template-list)))
    `(progn ,@defparameter-list)))

(lucerne:defapp app
    :middlewares
  (clack.middleware.session:<clack-middleware-session>
   (clack.middleware.static:<clack-middleware-static>
    :path "/static/"
    :root (relative-path #P"static/"))))

(defun start-server ()
  (lucerne:stop app)
  (lucerne:start app))

(defun stop-server ()
  (lucerne:stop app))

(defun start-app (&key (deploy nil) (reload-system nil))
  (when reload-stash
    (ql:quickload :stash))
  (when deploy
    (delpoy))
  (start-server))
