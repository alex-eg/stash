(in-package :stash.views)

(defun generate-css (lass-sheet path)
  (with-open-file (css-file path :direction :output
                            :if-exists :overwrite))
  (lass:write-sheet lass-sheet css-file))

(defun general-css)
(generate-css
 '(div.login
   :background "#0088EE"
   :boreder-radius "12px"
   :padding "20px")
 #P"./main.css")
