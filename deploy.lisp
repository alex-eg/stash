(in-package :stash)

(defun generate-css ()
  (generate-general-css #P"static/main.css")
  (generate-pygments-css "tango" #P"static/pygments.css"))

(defun initialize-database ()
  (with-database (db "stash")
    (create-index (make-instance 'user)
                  (plist->hash (list "login" 1))
                  db)))

(defun deploy ()
  "Copy files, write paths, initialize database with initial
user data"
  (generate-css)
  (download-jquery #P"static/jquery.js")
  (djula:add-template-directory (relative-path #P"views/"))
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
  (initialize-database)
  (with-database (db "stash")
    (store-one (make-instance 'user
                          :login "login"
                          :handle "Haru6aTop"
                          :adminp nil
                          :password (string->hash "TpyCuKu"))
           db)))
