(in-package :stash.views)

(define-view simple-script (params)
  (:script
   (defun change-color ()
     (let ((box (chain  document (get-element-by-id "box")))
           (new-color (ps::>> (* (chain |Math| (random))
                                 0xFFFFFF)
                              0)))
       (setf (@ box style background-color)
             (+ "#" (chain new-color
                      (to-string 16)))))))
  (str (header params))
  (:div :id "box")
  (:br)
  (:button :type "button"
           :onclick "changeColor()"
           (str "Click me!")))
