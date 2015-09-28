(in-package :stash.views)

(defun generate-css-and-save-to-file (path &rest lass-blocks)
  (format t "Generating css to ~s~%" (merge-pathnames path *default-pathname-defaults*))
  (with-open-file (css-file (merge-pathnames path *default-pathname-defaults*)
                            :direction :output
                            :if-does-not-exist :create
                            :if-exists :supersede)
    (lass:write-sheet (apply #'lass:compile-sheet lass-blocks)
                      :stream css-file)))

(defun generate-general-css ()
  (generate-css
   '(div.login
     :border "2px solid #8AC007"
     :background "#0088EE"
     :boreder-radius "12px"
     :padding "20px")
   #P"/static/main.css"))
