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
     :font-size 110%)
   '(input
     :font-size inherit)
   '(div.login
     :border 1px solid "#A0A0A0"
     :margin auto
     :background "#FAFAFA"
     :padding 3px
     :width 600px)
   '("div#box"
     :border 1px solid "#000"
     :padding 100px 100px 0px 0px
     :display "inline-block"
     :margin 10px 0px 10px 0px
     :background-color "#DFF")
   '(form
     ((:and input
       (:= type (:or text password)))
      :padding 0px 0px 0px 0px
      :margin 3px 0px 0px 3px
      :border 0px
      :background-color "#F0F0F0"
      :width 450px)
     ((:and input (:= type submit))
       :padding 0px 0px 0px 0px
       :margin 20px 0px 10px 0px
       :background-color "#eaeaea"
       :border solid 1px "#6b0000"
       :border-left none
       :border-right none
       :width 580px)
     (label
       :padding 0px 0px 0px 0px
       :margin 3px 0px 0px 3px
       :display inline-block
       :text-align right
       :width 100px))
   '(ul.header
     :list-style-type "none"
     :margin 0
     :padding 0
     :overflow "hidden"
     :border solid 1px "#6b0000"
     :border-bottom solid 20px "#000000"
     (li
      :float "left"
      :display "inline-block"
      :border-right solid 1px "#6b0000"
      (a
       :display "block"
       :width 100px
       :padding 14px 0px 16px 0px
       :text-align "center"
       :text-decoration "none"
       :background-color "#eaeaea")
      ((:and a :hover)
       :background-color "#0eeaea")))))
