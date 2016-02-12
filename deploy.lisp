(in-package :stash)

(defun generate-css ()
  (generate-general-css #P"static/main.css")
  (generate-pygments-css "tango" #P"static/pygments.css"))

(defun deploy ()
  "Copy files, write paths, initialize database with initial
user data"
  (generate-css)
  (download-jquery #P"static/jquery.js"))
