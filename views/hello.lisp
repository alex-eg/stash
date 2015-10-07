(in-package :stash.views)

(define-view hello-page (params)
  (str (header params))
  (:script (format nil "
function greet() {
    document.getElementById(\"hello-p\").innerHTML += ~S;
}" (cdr (assoc :name params))))
  (:div :id "hello-area"
        (:p (:b :id "hello-p" (str "Hello,")))
        (:button :type "button" :onclick "greet()" (str "Greet!"))))
