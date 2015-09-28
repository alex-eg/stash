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
  (generate-css-and-save-to-file
   #P"static/main.css"
   '(html
     :font-family monospace
     :font-size 130%)
   '(div.login
     :border 1px solid "#A0A0A0"
     :margin auto
     :background "#FAFAFA"
     :padding 3px
     :width 506px)
   '(form ((:and input
            (:= type (:or text password)))
           :padding 0px 0px 0px 0px
           :margin 0px 0px 0px 0px
           :border 0px
           :background-color "#F0F0F0"
           :width 400px))
   '(form ((:and input (:= type submit))
           :padding 0px 0px 0px 0px
           :margin 0px 0px 0px 0px
           :background-color "#eaeaea"
           :border solid 1px "#6b0000"
           :border-left none
           :border-right none
           :width 500px))
   '(form (label
           :padding 0px 0px 0px 0px
           :margin 0px 0px 0px 0px
           :display inline-block
           :text-align right
           :float left
           :width 100px))))
