(in-package :stash)

(lucerne:defapp app
    :middlewares
  (clack.middleware.session:<clack-middleware-session>
   (clack.middleware.static:<clack-middleware-static>
    :path "/static/"
    :root (relative-path #P"static/"))))

(defun start-server ()
  (lucerne:start app))

(defun stop-server ()
  (lucerne:stop app))

(defun start-app (&key (deploy nil) (reload-system nil))
  (when reload-system
    (ql:quickload :stash))
  (when deploy
    (deploy))
  (init-config (relative-path #P"conf.lisp"))
  (stop-server)
  (start-server))
